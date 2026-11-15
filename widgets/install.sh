#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LAYOUT="$REPO_ROOT/widgets/layout.json"

WHIMSY="$HOME/.config/omarchy/plugins/whimsy"
MODEL="$WHIMSY/Model.js"
STATE_DIR="$HOME/.local/state/omarchy/whimsy"
STATE="$STATE_DIR/widgets.json"

echo "===== MaDev Widget Installer ====="

# Check required commands.
for cmd in python3 hyprctl; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: Required command not found: $cmd"
        exit 1
    fi
done

# Check Whimsy installation.
if [[ ! -f "$MODEL" ]]; then
    echo "ERROR: Whimsy is not installed."
    echo "Install it first:"
    echo "omarchy plugin add https://github.com/rover-001/whimsy.git --enable"
    exit 1
fi

if [[ ! -f "$LAYOUT" ]]; then
    echo "ERROR: MaDev layout file not found: $LAYOUT"
    exit 1
fi

# Verify that all requested widget styles exist in Whimsy.
echo "Checking widget compatibility..."

python3 - "$LAYOUT" "$MODEL" <<'PY'
import json
import re
import sys
from pathlib import Path

layout_path = Path(sys.argv[1])
model_path = Path(sys.argv[2])

layout = json.loads(layout_path.read_text())
model = model_path.read_text()

for widget in layout["widgets"]:
    style = widget["style"]
    pattern = rf'id:\s*"{re.escape(style)}"'

    if not re.search(pattern, model):
        print(f"ERROR: Whimsy does not provide widget style: {style}")
        sys.exit(1)

print(f"Verified {len(layout['widgets'])} widget styles.")
PY

# Never overwrite an existing layout without explicit confirmation.
if [[ -f "$STATE" ]]; then
    echo
    echo "An existing Whimsy layout was found:"
    echo "$STATE"
    echo
    read -r -p "Replace it with the MaDev layout? A backup will be created. [y/N] " answer

    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
        echo "Installation cancelled. Existing layout unchanged."
        exit 0
    fi
fi

# Generate the Whimsy-compatible state file.
python3 - "$LAYOUT" "$STATE" <<'PY'
import json
import os
import subprocess
import sys
import tempfile
import uuid
import shutil
from datetime import datetime
from pathlib import Path

layout_path = Path(sys.argv[1])
state_path = Path(sys.argv[2])

layout = json.loads(layout_path.read_text())

# Detect the primary monitor.
result = subprocess.run(
    ["hyprctl", "-j", "monitors"],
    capture_output=True,
    text=True,
    check=True
)

monitors = json.loads(result.stdout)

if not monitors:
    raise SystemExit("ERROR: No active monitor detected.")

monitor = next(
    (m for m in monitors if m.get("focused")),
    monitors[0]
)
monitor_name = monitor["name"]
monitor_scale = float(monitor["scale"])

logical_width = round(monitor["width"] / monitor_scale)
logical_height = round(monitor["height"] / monitor_scale)

base = layout["base_resolution"]

# Convert the portable layout into Whimsy's native format.
widgets = []

for item in layout["widgets"]:
    widgets.append({
        "id": "w" + uuid.uuid4().hex[:12],
        "style": item["style"],
        "screen": monitor_name,
        "x": round(item["x"] * logical_width / base["width"]),
        "y": round(item["y"] * logical_height / base["height"]),
        "scale": item.get("scale", 1.0),
        "locked": item.get("locked", False),
        "rotation": item.get("rotation", 0)
    })

state_path.parent.mkdir(parents=True, exist_ok=True)

# Back up the current layout before replacing it.
if state_path.exists():
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S-%f")
    backup_path = state_path.with_name(
        f"widgets.json.backup-{timestamp}"
    )

    shutil.copy2(state_path, backup_path)
    print(f"Backup created: {backup_path}")

# Write to a temporary file, then atomically replace the state file.
with tempfile.NamedTemporaryFile(
    mode="w",
    encoding="utf-8",
    dir=state_path.parent,
    prefix=".widgets-",
    suffix=".tmp",
    delete=False
) as temporary:
    json.dump(widgets, temporary, indent=2)
    temporary.write("\n")
    temporary_path = Path(temporary.name)

try:
    os.replace(temporary_path, state_path)
except Exception:
    temporary_path.unlink(missing_ok=True)
    raise

print()
print(f"Monitor: {monitor_name}")
print(f"Logical resolution: {logical_width} x {logical_height}")
print(f"Widgets installed: {len(widgets)}")
print(f"State file: {state_path}")
PY

echo
echo "MaDev widget layout applied."
echo "Whimsy should reload the layout automatically."
