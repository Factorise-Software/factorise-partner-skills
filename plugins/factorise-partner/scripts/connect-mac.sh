#!/bin/bash
# Save, list or remove the Factorise logins that curl reads (~/.factorise/netrc, readable only by
# this user). Prints only an outcome and environment addresses, never a user name or password.
#
#   bash connect-mac.sh <environment host>          ask for the login in two dialogs and save it
#   bash connect-mac.sh list                        the addresses a login is saved for
#   bash connect-mac.sh forget <environment host>   remove the login saved for that address
#
# A host looks like acme.factorise-suite.com.
set -u

f="$HOME/.factorise/netrc"
mode=save
case "${1:-}" in
  list) mode=list ;;
  forget) mode=forget; shift ;;
esac

if [ -e "$f" ] && { [ ! -f "$f" ] || [ ! -r "$f" ]; }; then
  echo "Not done: the file with your saved logins can't be read, so it was left as it is."; exit 4
fi

if [ "$mode" = list ]; then
  # Only names that look like a host are printed, whatever else the file holds.
  hosts=$([ -f "$f" ] && awk '$(1)=="machine" && tolower($(2)) ~ /^[a-z0-9][a-z0-9.-]*\.[a-z][a-z]+$/ {print tolower($(2))}' "$f" 2>/dev/null | sort -u | tr '\n' ' ')
  if [ -n "${hosts% }" ]; then echo "Logins saved for: ${hosts% }"; else echo "No logins saved."; fi
  exit 0
fi

# Lower case, so one environment is never saved twice. A name, not a number: it starts with a
# letter or digit and ends in letters.
h=$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]')
if ! [[ "$h" =~ ^[a-z0-9][a-z0-9-]*(\.[a-z0-9-]+)*\.[a-z]{2,}$ ]]; then
  echo "Not done: the address should look like acme.factorise-suite.com, without https:// or a port."; exit 2
fi

umask 077

# without_host: the saved logins, apart from this host's.
without_host() { [ -f "$f" ] && awk -v h="$h" '!($(1)=="machine" && tolower($(2))==h)' "$f"; }

if [ "$mode" = forget ]; then
  if [ ! -f "$f" ] || ! awk -v h="$h" '$(1)=="machine" && tolower($(2))==h {found=1} END {exit !found}' "$f"; then
    echo "No login was saved for $h."; exit 0
  fi
  { without_host; } 2>/dev/null > "$f.new" && chmod 600 "$f.new" && mv "$f.new" "$f" || { rm -f "$f.new"; echo "Not done: the file with your saved logins couldn't be changed."; exit 4; }
  [ -s "$f" ] || rm -f "$f"
  echo "Removed the login for $h."; exit 0
fi

# The password goes to this address with the first call, so an address outside Factorise's own
# domain is pointed out in the window itself, where the person typing sees it.
note=""
case "$h" in
  *.factorise-suite.com) ;;
  *) note="Note: $h is not an address on factorise-suite.com. Only go on if you're sure it's your Factorise environment.

" ;;
esac

# ask <question> plain|hidden: show a dialog and print the answer. Gives up after 2.5 minutes, so both fit in the skill's 6-minute timeout.
ask() {
  osascript - "$h" "$1" "$2" <<'APPLESCRIPT' 2>"$errf"
on run argv
  set theHost to item 1 of argv
  set theQuestion to item 2 of argv
  set theTitle to "Factorise login for " & theHost
  if item 3 of argv is "hidden" then
    set r to display dialog theQuestion default answer "" with title theTitle with hidden answer buttons {"Cancel", "Save"} default button "Save" with icon note giving up after 150
  else
    set r to display dialog theQuestion default answer "" with title theTitle buttons {"Cancel", "Next"} default button "Next" with icon note giving up after 150
  end if
  if gave up of r then error number -128
  return text returned of r
end run
APPLESCRIPT
}

# osascript's error text says why a dialog failed; it never contains what was typed.
errf=$(mktemp); trap 'rm -f "$errf"' EXIT
failed() {
  if grep -q -- '-128' "$errf"; then echo "Cancelled. Nothing saved."; exit 1; fi
  echo "Not saved: the login window couldn't open on this Mac."; exit 4
}

u=$(ask "${note}User name of the Factorise account you made for Claude:" plain) || failed
p=$(ask "Password for $u. It goes straight into a file only you can read, not into the chat." hidden) || failed

for v in "$u" "$p"; do
  case "$v" in
    ''|*[[:space:]\"\\#]*) echo "Not saved: the user name or password is empty, or has a space, quote, # or backslash in it."; exit 3 ;;
  esac
done

mkdir -p "$HOME/.factorise" && {
  without_host
  printf 'machine %s login %s password %s\n' "$h" "$u" "$p"
} 2>/dev/null > "$f.new" && chmod 600 "$f.new" && mv "$f.new" "$f" && { echo "Saved"; exit 0; }
rm -f "$f.new"
echo "Not saved: the file with your saved logins couldn't be written."; exit 4
