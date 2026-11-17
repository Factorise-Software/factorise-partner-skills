#!/bin/bash
# Get the Factorise docs pack: open its address in the default browser, where the partner signs
# in with their own docs login, wait for the download, check it and unpack it. Nothing here
# signs in or handles a login. Prints only the outcome, on one line.
#
#   bash get-docs-mac.sh <folder to unpack into> [refresh]
#
# "refresh" replaces a pack that is already there with a newly downloaded one. A pack downloaded
# more than 14 days ago is replaced too, and kept if no new one arrives.
set -u

url="https://docs.factorise-suite.com/downloads/factorise-docs-pack.zip"
dest="${1:-}"
refresh="${2:-}"
dl="${FACTORISE_DOWNLOADS:-$HOME/Downloads}"   # the variable is for testing only
wait_s="${FACTORISE_WAIT:-300}"
[ -n "$dest" ] || { echo "Not ready: no folder was given to unpack the docs into."; exit 2; }

built_of() { sed -n -E 's/.*"built" *: *"([0-9-]+)".*/\1/p' "$1/pack.json" 2>/dev/null | head -1; }

# stop <code> <message>: end with the message, or, when only renewing an old pack, keep that one.
keep=""
stop() {
  if [ -n "$keep" ]; then echo "Ready: docs pack of $keep, downloaded more than 14 days ago. A new one didn't arrive."; exit 0; fi
  echo "$2"; exit "$1"
}

if [ "$refresh" != "refresh" ] && [ -f "$dest/pack.json" ] && [ -f "$dest/INDEX.md" ]; then
  if [ -z "$(find "$dest/.downloaded" -mtime +13 2>/dev/null)" ] && [ -f "$dest/.downloaded" ]; then
    echo "Ready: docs pack of $(built_of "$dest")"; exit 0
  fi
  keep=$(built_of "$dest"); wait_s="${FACTORISE_WAIT:-120}"
fi

work=$(mktemp -d); trap 'rm -rf "$work"' EXIT

# newest [find test...]: the newest docs pack in Downloads or next to the destination that passes
# the test. A zip, or the folder Safari leaves when it unpacks a download by itself.
newest() {
  find "$dl" "$(dirname "$dest")" -maxdepth 1 -name 'factorise-docs-pack*' \
    \( -name '*.zip' -o -type d \) "$@" -print0 2>/dev/null | xargs -0 ls -dt 2>/dev/null | head -1
}

# use <zip or folder>: check it and put it in place. Returns 1 while a download is still being
# written, and exits with the outcome otherwise.
use() {
  local src="$1" root
  rm -rf "$work/x"; mkdir "$work/x"
  if [ -d "$src" ]; then
    [ -f "$src/pack.json" ] || return 1
    cp -R "$src" "$work/x/pack"
  else
    unzip -tqq "$src" >/dev/null 2>&1 || return 1
    if unzip -Z1 "$src" | grep -qE '(^/|(^|/)\.\.(/|$))'; then
      stop 3 "Not ready: the downloaded file isn't a Factorise docs pack."
    fi
    unzip -qq "$src" -d "$work/x" || return 1
  fi
  root=$(dirname "$(find "$work/x" -maxdepth 2 -name pack.json | head -1)" 2>/dev/null)
  if [ -z "$root" ] || [ ! -f "$root/INDEX.md" ] || ! grep -qE '"format" *: *1[^0-9]' "$root/pack.json"; then
    stop 3 "Not ready: the downloaded file isn't a docs pack this version of make-demo can read."
  fi
  rm -rf "$dest.old"
  [ -e "$dest" ] && mv "$dest" "$dest.old"
  if ! { mkdir -p "$(dirname "$dest")" && mv "$root" "$dest"; }; then
    [ -e "$dest.old" ] && mv "$dest.old" "$dest"
    stop 4 "Not ready: couldn't write to $dest."
  fi
  touch "$dest/.downloaded"
  rm -rf "$dest.old" "$src"
  echo "Ready: docs pack of $(built_of "$dest")"; exit 0
}

# A pack downloaded in the last hour, such as after an earlier run timed out during sign-in.
# One that can't be used is skipped here, and a new one is downloaded.
recent=$(newest -mmin -60)
if [ -n "$recent" ] && out=$(use "$recent"); then echo "$out"; exit 0; fi

touch "$work/start"
open "$url" 2>/dev/null || stop 4 "Not ready: couldn't open the browser on this Mac."

waited=0
while [ "$waited" -lt "$wait_s" ]; do
  sleep 3; waited=$((waited + 3))
  found=$(newest -newer "$work/start")
  [ -n "$found" ] && use "$found"
done
stop 1 "Not downloaded: no docs pack arrived in the Downloads folder within $((wait_s / 60)) minutes."
