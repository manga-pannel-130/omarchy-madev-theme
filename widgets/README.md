# MaDev Desktop Widgets

MaDev includes a portable default desktop widget arrangement powered by
[Whimsy](https://github.com/rover-001/whimsy), an Omarchy plugin built with
Quickshell.

The layout includes six widgets:

| Widget | Purpose |
|---|---|
| `visualizer-bars` | Live audio visualizer |
| `sys-pill-cpu` | CPU monitoring |
| `sys-pill-ram` | Memory monitoring |
| `sys-pill-gpu` | GPU monitoring |
| `music-vinyl` | Music player |
| `analog-station` | Analog clock |

## Requirements

- Omarchy Linux
- Hyprland
- Python 3
- Whimsy plugin
- PipeWire for the audio visualizer

Whimsy is maintained separately and is not bundled with MaDev.

## Installation

### 1. Install Whimsy

If it is not already installed:

```bash
omarchy plugin add https://github.com/rover-001/whimsy.git --enable
```

Review third-party plugin code and installation requirements before enabling it.

### 2. Apply the MaDev layout

Run:

```bash
bash "$HOME/.config/omarchy/themes/madev/widgets/install.sh"
```

The installer:

- Checks that Whimsy is installed.
- Verifies that all six widget styles are available.
- Detects the currently focused monitor.
- Adapts widget positions to the monitor's logical resolution.
- Generates fresh widget IDs.
- Backs up an existing Whimsy layout before replacing it.
- Applies the MaDev arrangement.

If an existing layout is found, the installer asks for confirmation before replacing it.

## Restore your previous layout

Run:

```bash
bash "$HOME/.config/omarchy/themes/madev/widgets/restore.sh"
```

The restore script finds the latest MaDev-created backup and asks for confirmation.

It also preserves the current layout before restoring the backup.

## Layout customization

The default arrangement is defined in `layout.json`.

Positions are based on a logical resolution of 1280 × 720. The installer scales coordinates according to the detected monitor dimensions.

You can modify widget positions, scales, lock states, and rotation in this file.

## Compatibility notes

- Widget styles must be provided by the installed Whimsy version.
- Whimsy's stock GPU monitoring implementation uses `nvidia-smi`. AMD GPU telemetry is not supported by that stock implementation.
- GPU temperature and other hardware metrics depend on the capabilities of the installed monitoring implementation.
- Music metadata and playback controls depend on an available MPRIS-compatible media player.
- The live visualizer requires a working PipeWire audio environment.

MaDev provides the default layout and installation scripts; Whimsy provides the widget framework and functionality.
