#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="$HOME/.local/state/omarchy/whimsy"
STATE="$STATE_DIR/widgets.json"

echo "===== MaDev Widget Layout Restore ====="

if [[ ! -f "$STATE" ]]; then
    echo "ERROR: No current Whimsy layout found."
    exit 1
fi

BACKUP="$(find "$STATE_DIR" -maxdepth 1 -type f \
    -name 'widgets.json.backup-*' -printf '%T@ %p\n' |
    sort -nr | head -n 1 | cut -d' ' -f2-)"

if [[ -z "$BACKUP" || ! -f "$BACKUP" ]]; then
    echo "ERROR: No backup layout found."
    exit 1
fi

echo "Latest backup:"
echo "$BACKUP"
echo
read -r -p "Restore this backup? [y/N] " answer

if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    echo "Restore cancelled."
    exit 0
fi

cp -p "$STATE" "$STATE_DIR/widgets.json.before-restore-$(date +%Y%m%d-%H%M%S-%N)"

TEMP="$(mktemp "$STATE_DIR/.widgets-restore.XXXXXX")"
trap 'rm -f "$TEMP"' EXIT

cp -- "$BACKUP" "$TEMP"
mv -f -- "$TEMP" "$STATE"

echo "Previous layout restored."
echo "Whimsy should reload it automatically."
