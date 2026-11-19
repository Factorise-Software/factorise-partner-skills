#!/bin/bash
# Ask for the Factorise login in two Mac dialogs and save it where curl reads it
# (~/.factorise/netrc, readable only by this user). Prints only the outcome, never the login.
#
#   bash connect-mac.sh <environment host, such as acme.factorise-suite.com>
set -u

# Lower case, so one environment is never saved twice. A name, not a number: it starts with a
# letter or digit and ends in letters.
h=$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]')
if ! [[ "$h" =~ ^[a-z0-9][a-z0-9-]*(\.[a-z0-9-]+)*\.[a-z]{2,}$ ]]; then
  echo "Not saved: the address should look like acme.factorise-suite.com, without https:// or a port."; exit 2
fi

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

u=$(ask "User name of the Factorise account you made for Claude:" plain) || failed
p=$(ask "Password for $u. It goes straight into a file only you can read, not into the chat." hidden) || failed

for v in "$u" "$p"; do
  case "$v" in
    ''|*[[:space:]\"\\#]*) echo "Not saved: the user name or password is empty, or has a space, quote, # or backslash in it."; exit 3 ;;
  esac
done

f="$HOME/.factorise/netrc"
if [ -e "$f" ] && { [ ! -f "$f" ] || [ ! -r "$f" ]; }; then
  echo "Not saved: the file with your saved logins can't be read, so it was left as it is."; exit 4
fi
umask 077
mkdir -p "$HOME/.factorise"
{
  [ -f "$f" ] && awk -v h="$h" '!($1=="machine" && tolower($2)==h)' "$f"
  printf 'machine %s login %s password %s\n' "$h" "$u" "$p"
} > "$f.new" && mv "$f.new" "$f" && chmod 600 "$f" && echo "Saved"
