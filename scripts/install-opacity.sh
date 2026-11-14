#!/usr/bin/env bash
set -euo pipefail

CONFIG="$HOME/.config/hypr/looknfeel.lua"

if [[ ! -f "$CONFIG" ]]; then
    echo "ERROR: $CONFIG not found."
    exit 1
fi

python3 - "$CONFIG" <<'PY'
from pathlib import Path
from datetime import datetime
import shutil
import sys

config = Path(sys.argv[1])
begin = "-- >>> MaDev global window opacity >>>"
end = "-- <<< MaDev global window opacity <<<"

block = """-- >>> MaDev global window opacity >>>
-- Applies to all Hyprland-managed application windows.
hl.config({
  decoration = {
    active_opacity = 0.80,
    inactive_opacity = 0.75,
  },
})
-- <<< MaDev global window opacity <<<"""

original = config.read_text()
updated = original

# Remove every existing MaDev-managed opacity block.
while begin in updated:
    start = updated.index(begin)
    finish = updated.find(end, start)

    if finish == -1:
        print("ERROR: Found an incomplete MaDev opacity block. No changes made.")
        sys.exit(1)

    finish += len(end)
    if finish < len(updated) and updated[finish] == "\n":
        finish += 1

    updated = updated[:start] + updated[finish:]

# Add exactly one clean block.
updated = updated.rstrip() + "\n\n" + block + "\n"

if updated == original:
    print("MaDev opacity is already installed correctly. No changes needed.")
    sys.exit(0)

backup = config.with_name(
    config.name + ".bak." + datetime.now().strftime("%Y%m%d-%H%M%S")
)
shutil.copy2(config, backup)
config.write_text(updated)

print("MaDev global opacity installed successfully.")
print(f"Backup: {backup}")
print("Active opacity: 0.80")
print("Inactive opacity: 0.75")
PY
