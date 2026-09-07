#!/usr/bin/env bash
# xpad-cleanpads.sh — prune stale/empty xpad pads, keep the layout template.
#
# Each xpad pad = one info-<ID> file (layout metadata + a `content <file>` line
# pointing at its text file). This script deletes WHOLE pads (info + content),
# and NEVER touches default-style (new-pad template) or server (IPC socket).
#
# Rules:
#   - pads whose content file is empty (0 bytes) are removed (unless active <1h)
#   - pads with no activity (max mtime of info+content) older than
#     MAX_AGE_DAYS are removed
#   - orphan content-* files not referenced by any info-* file are removed
#     (crash leftovers); orphan info-* files likewise
#   - anything modified within the last hour is never touched
#
# Usage:
#   xpad-cleanpads.sh [--max-age-days N] [--dry-run]
# Env override: XPAD_DIR (default $HOME/.config/xpad)
set -euo pipefail

XPAD_DIR="${XPAD_DIR:-$HOME/.config/xpad}"
MAX_AGE_DAYS=7
DRY_RUN=0

while (($#)); do
  case "$1" in
    --max-age-days) MAX_AGE_DAYS="$2"; shift 2 ;;
    --dry-run|-n) DRY_RUN=1; shift ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

[[ -d "$XPAD_DIR" ]] || { echo "ok: $XPAD_DIR does not exist, nothing to clean"; exit 0; }

NOW=$(date +%s)
FLOOR=$((60 * 60))                       # never touch anything active in the last hour
MAX_AGE=$((MAX_AGE_DAYS * 86400))
removed=0
freed=0

del() {  # del <file...>
  local f
  for f in "$@"; do
    [[ -e "$f" ]] || continue
    if (( DRY_RUN )); then
      echo "would delete: $f"
    else
      freed=$((freed + $(stat -c %s "$f" 2>/dev/null || echo 0)))
      rm -f -- "$f"
      removed=$((removed + 1))
    fi
  done
}

# 1) Collect content files referenced by info-* files (by basename).
declare -A referenced
for info in "$XPAD_DIR"/info-*; do
  [[ -e "$info" ]] || continue
  while read -r key val; do
    if [[ "$key" == "content" && -n "$val" ]]; then
      referenced["$val"]=1
    fi
  done < "$info"
done

# 2) Delete whole pads (info + its content file) that are empty or stale.
for info in "$XPAD_DIR"/info-*; do
  [[ -e "$info" ]] || continue
  cfile=$(awk '/^content /{print $2; exit}' "$info")
  cpath="$XPAD_DIR/$cfile"
  [[ -f "$cpath" ]] || cpath=""          # info references a missing content file

  mtime=$(stat -c %Y "$info")
  if [[ -n "$cpath" ]]; then
    cmt=$(stat -c %Y "$cpath")
    (( cmt > mtime )) && mtime=$cmt      # activity = newest of info/content mtime
  fi
  age=$((NOW - mtime))
  (( age < FLOOR )) && continue

  empty=0
  [[ -n "$cpath" && ! -s "$cpath" ]] && empty=1
  if (( empty || age > MAX_AGE )); then
    del "$info" "$cpath"
  fi
done

# 3) Orphan content files not referenced by any info-* (crash leftovers).
for c in "$XPAD_DIR"/content-*; do
  [[ -e "$c" ]] || continue
  b=$(basename "$c")
  [[ -n "${referenced[$b]:-}" ]] && continue
  age=$((NOW - $(stat -c %Y "$c")))
  (( age < FLOOR )) && continue
  if (( age > MAX_AGE || ! -s "$c" )); then
    del "$c"
  fi
done

echo "xpad-cleanpads: removed=$removed freed=$freed B (max-age=${MAX_AGE_DAYS}d; kept: default-style, server)"
exit 0
