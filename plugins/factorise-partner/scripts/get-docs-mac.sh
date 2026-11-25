#!/bin/bash
# Get the Factorise docs pack: open its address in the default browser, where the partner signs
# in with their own docs login, wait for the download, check it and unpack it. Nothing here
# signs in or handles a login. Prints only the outcome, on one line.
#
#   bash get-docs-mac.sh <folder to unpack into> [refresh|check]
#
# "check" only says whether a download is needed ("Needed"), or due for a pack that's getting
# old ("Renew"), and opens nothing.
# "refresh" replaces a pack that is already there with a newly downloaded one. A pack downloaded
# more than 14 days ago is replaced too, and kept if no new one arrives.
set -u

url="https://docs.factorise-suite.com/downloads/factorise-docs-pack.zip"
dest="${1:-}"
refresh="${2:-}"
dl="${FACTORISE_DOWNLOADS:-$HOME/Downloads}"   # the variable is for testing only
wait_s="${FACTORISE_WAIT:-150}"
[ -n "$dest" ] || { echo "Not ready: no folder was given to unpack the docs into."; exit 2; }

# The folder is replaced whole with every new pack, so it must be one of ours: called
# factorise-docs, and either not there yet, empty, or holding a pack already.
while [ "${dest%/}" != "$dest" ]; do dest="${dest%/}"; done
case "$dest" in /*) ;; *) dest="$PWD/$dest" ;; esac
if [ "$(basename "$dest")" != "factorise-docs" ]; then
  echo "Not ready: the docs folder has to be called factorise-docs."; exit 2
fi
if [ -e "$dest" ] || [ -L "$dest" ]; then
  if [ -L "$dest" ] || [ ! -d "$dest" ] || { [ -n "$(ls -A "$dest" 2>/dev/null)" ] && ! { [ -f "$dest/pack.json" ] && [ -f "$dest/INDEX.md" ]; }; }; then
    echo "Not ready: $dest already holds something that isn't a docs pack. Move it somewhere else first."; exit 4
  fi
fi
# Where the pack that's there waits while the new one is put in place. Never a name of the partner's.
old="$(dirname "$dest")/.factorise-docs.replaced.$$"

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
  keep=$(built_of "$dest")
fi

work=$(mktemp -d); trap 'rm -rf "$work"' EXIT

# newest [find test...]: the newest docs pack in Downloads or next to the destination that passes
# the test. A zip, or the folder Safari leaves when it unpacks a download by itself.
newest() {
  find "$dl" "$(dirname "$dest")" -maxdepth 1 -name 'factorise-docs-pack*' \
    \( -name '*.zip' -o -type d \) "$@" -print0 2>/dev/null | xargs -0 ls -dt 2>/dev/null | head -1
}

# from_docs_site <zip or folder>: false when the browser recorded where the download came from
# and that isn't the docs site. A file with no such record, such as one copied by hand, passes.
from_docs_site() {
  local from
  from=$(xattr -px com.apple.metadata:kMDItemWhereFroms "$1" 2>/dev/null | xxd -r -p | plutil -convert xml1 -o - - 2>/dev/null) || return 0
  [ -n "$from" ] || return 0
  # The first address is the download's own; a second one is only the page that linked to it.
  case "$(printf '%s\n' "$from" | sed -n -E 's/.*<string>(.*)<\/string>.*/\1/p' | head -1)" in
    https://docs.factorise-suite.com/*) return 0 ;;
    *) return 1 ;;
  esac
}

# use <zip or folder>: check it and put it in place. Returns 1 while a download is still being
# written, and exits with the outcome otherwise.
use() {
  local src="$1" root
  rm -rf "$work/x"; mkdir "$work/x"
  if ! from_docs_site "$src"; then
    stop 3 "Not ready: $(basename "$src") didn't come from docs.factorise-suite.com, so it wasn't used. Remove it from the Downloads folder."
  fi
  if [ -d "$src" ]; then
    [ -f "$src/pack.json" ] || return 1
    if [ -n "$(find "$src" -type l | head -1)" ]; then
      stop 3 "Not ready: the downloaded file isn't a Factorise docs pack."
    fi
    cp -R "$src" "$work/x/pack"
  else
    unzip -tqq "$src" >/dev/null 2>&1 || return 1
    # No absolute paths, no "..", and no links: only plain files and folders are unpacked.
    if unzip -Z1 "$src" | grep -qE '(^/|(^|/)\.\.(/|$))' || unzip -Z "$src" | grep -q '^l'; then
      stop 3 "Not ready: the downloaded file isn't a Factorise docs pack."
    fi
    unzip -qq "$src" -d "$work/x" || return 1
  fi
  # Keep only the pages and pack.json. Nothing hidden, nothing that runs, and no file that Claude
  # Code would read as instructions of its own.
  find "$work/x" -mindepth 1 \( -name '.*' -o -name '__MACOSX' -o -iname 'CLAUDE*.md' -o -iname 'AGENTS.md' \) -prune -exec rm -rf {} +
  find "$work/x" ! -type d ! -name '*.md' ! -name 'pack.json' -exec rm -f {} +
  find "$work/x" -type f -exec chmod 644 {} +
  root=$(dirname "$(find "$work/x" -maxdepth 2 -name pack.json -type f | head -1)" 2>/dev/null)
  if [ -z "$root" ] || [ ! -f "$root/INDEX.md" ] || ! grep -qE '"format" *: *1[^0-9]' "$root/pack.json"; then
    # A pack in a newer format is ours, and no use to this version: don't leave it in Downloads.
    [ -n "$root" ] && [ -f "$root/INDEX.md" ] && rm -rf "$src"
    stop 3 "Not ready: the downloaded file isn't a docs pack this version of the plugin can read."
  fi
  if [ -e "$old" ] || ! mkdir -p "$(dirname "$dest")"; then stop 4 "Not ready: couldn't write to $dest."; fi
  if [ -e "$dest" ] && ! mv "$dest" "$old"; then stop 4 "Not ready: couldn't write to $dest."; fi
  if ! mv "$root" "$dest"; then
    [ -e "$old" ] && mv "$old" "$dest"
    stop 4 "Not ready: couldn't write to $dest."
  fi
  touch "$dest/.downloaded"
  rm -rf "$old" "$src"
  echo "Ready: docs pack of $(built_of "$dest")"; exit 0
}

# A pack downloaded in the last hour, such as after an earlier run timed out during sign-in.
# One that can't be used is skipped here, and a new one is downloaded.
recent=$(newest -mmin -60)
if [ -n "$recent" ] && out=$(keep=""; use "$recent"); then echo "$out"; exit 0; fi
if [ "$refresh" = "check" ]; then
  if [ -n "$keep" ]; then echo "Renew: docs pack of $keep, downloaded more than 14 days ago."; exit 0; fi
  echo "Needed: a docs pack has to be downloaded."; exit 0
fi

touch "$work/start"
open "$url" 2>/dev/null || stop 4 "Not ready: couldn't open the browser on this Mac."

waited=0
while [ "$waited" -lt "$wait_s" ]; do
  sleep 3; waited=$((waited + 3))
  found=$(newest -newer "$work/start")
  [ -n "$found" ] && use "$found"
done
stop 1 "Not downloaded: no docs pack arrived in the Downloads folder within $((wait_s / 60)) minutes."
