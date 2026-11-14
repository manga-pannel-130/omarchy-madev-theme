# MaDev Omarchy Theme

A custom Omarchy theme created and maintained by Vishal Madhav.

## Contents
- Custom color palette
- Theme icon configuration
- Desktop preview images
- Unlock screen assets
- Nine desktop wallpapers

## Installation

MaDev can be installed directly through Omarchy's built-in theme installer. Manual cloning is not required.

1. Open the Omarchy menu using `Super + Alt + Space`.
2. Navigate to **Install → Style → Theme**.
3. Paste the repository URL:

   `https://github.com/manga-pannel-130/MaDev-Omarchy-Theme.git`

4. Once installation finishes, select **MaDev** from the theme selector.

Alternatively, install MaDev from the terminal:

```bash
omarchy theme install https://github.com/manga-pannel-130/MaDev-Omarchy-Theme.git
```

## Window Opacity (Optional)

MaDev includes an optional installer for global Hyprland window opacity. It applies the same opacity settings to all application windows, so you do not need to identify or maintain individual window classes, including browser and PWA classes.

Default values:
- **Active windows:** 0.80 (80% opacity)
- **Inactive windows:** 0.75 (75% opacity)

The opacity installer is not run automatically when MaDev is installed. To enable it, run:

```bash
```
bash "$HOME/.config/omarchy/themes/madev-omarchy-theme/scripts/install-opacity.sh"

The installer adds a clearly marked configuration block to `~/.config/hypr/looknfeel.lua`, creates a timestamped backup before modifying the file, and can safely be run again without adding duplicate settings.

Reload Hyprland to apply the settings if necessary:

```bash
hyprctl reload
```

These are global settings: they affect all Hyprland-managed application windows, not just browsers. To change or remove them, edit or remove the MaDev-managed block in `~/.config/hypr/looknfeel.lua`.

## Updating

MaDev is installed as a Git repository. To retrieve the latest changes, run:

```bash
git -C "$HOME/.config/omarchy/themes/madev" pull --ff-only
```

After updating, reapply MaDev:

```bash
omarchy theme set madev
```

To check the installed theme name:

```bash
omarchy theme list
```
