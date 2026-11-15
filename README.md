# MaDev

A custom [Omarchy](https://omarchy.org) theme created and maintained by Vishal Madhav.

MaDev is a monochromatic desktop theme built around a clean black, white, and neutral-grey palette.

## Features

- Custom monochromatic color palette
- Theme-specific application and desktop styling
- Custom theme icons
- Desktop preview images
- Unlock screen assets
- Nine desktop wallpapers
- Custom Fastfetch configuration featuring a Porsche 911 GT3 RS ASCII/SIXEL logo
- Optional global Hyprland window opacity installer

## Installation

MaDev can be installed directly using Omarchy's built-in theme installer. You do not need to clone the repository manually.

### Using the Omarchy menu

1. Open the Omarchy menu with `Super + Alt + Space`.
2. Navigate to **Install → Style → Theme**.
3. Enter the repository URL:

   `https://github.com/manga-pannel-130/omarchy-madev-theme.git`
4. Complete the installation.
5. Select **Madev** from the theme selector.

> **Note:** If MaDev is not yet listed in the community theme browser, you can still install it directly using the repository URL.

### Using the terminal

Run:

```bash
omarchy theme install https://github.com/manga-pannel-130/omarchy-madev-theme.git
```

If MaDev is not already active, select it:

```bash
omarchy theme set madev
```

Omarchy installs this repository under:

```text
~/.config/omarchy/themes/madev/
```

## Updating

MaDev is installed as a Git repository. You can update it whenever a new version is published.

### 1. Pull the latest changes

```bash
git -C "$HOME/.config/omarchy/themes/madev" pull --ff-only
```

The `--ff-only` option prevents Git from creating an unexpected merge commit during an update.

### 2. Reapply MaDev

```bash
omarchy theme set madev
```

This reloads MaDev using the latest installed theme files.

### 3. Verify the active theme

```bash
omarchy theme current
```

The expected output is:

```text
Madev
```

## Fastfetch Configuration

MaDev includes a custom Fastfetch configuration with a Porsche 911 GT3 RS logo and system information arranged to match the theme's visual style.

The configuration is located at:

```text
~/.config/omarchy/themes/madev/fastfetch/config.jsonc
```

To run Fastfetch using the MaDev configuration:

```bash
fastfetch --config "$HOME/.config/omarchy/themes/madev/fastfetch/config.jsonc"
```

This explicitly uses MaDev's configuration without replacing your existing default Fastfetch configuration.

### Set MaDev as the Global Fastfetch Configuration (Optional)

You can make MaDev's Fastfetch configuration your global default. This allows you to run `fastfetch` without specifying a configuration path every time.

Create the Fastfetch configuration directory:

```bash
mkdir -p "$HOME/.config/fastfetch"
```

Back up your existing configuration if one is present:

```bash
if [ -e "$HOME/.config/fastfetch/config.jsonc" ] || [ -L "$HOME/.config/fastfetch/config.jsonc" ]; then
    cp -a "$HOME/.config/fastfetch/config.jsonc" \
      "$HOME/.config/fastfetch/config.jsonc.backup"
fi
```

Link MaDev's configuration as the global default:

```bash
ln -sfn "$HOME/.config/omarchy/themes/madev/fastfetch/config.jsonc" \
  "$HOME/.config/fastfetch/config.jsonc"
```

Now run:

```bash
fastfetch
```

Fastfetch will use MaDev's configuration by default.

**Note:** This setup makes MaDev's Fastfetch configuration global, independently of your currently selected Omarchy theme. If you switch to another theme, Fastfetch will continue using MaDev's configuration until you change the link.

To restore your previous configuration, remove the symlink and restore your backup:

```bash
rm "$HOME/.config/fastfetch/config.jsonc"
cp -a "$HOME/.config/fastfetch/config.jsonc.backup" \
  "$HOME/.config/fastfetch/config.jsonc"
```

If you did not have a previous configuration, simply remove the symlink.

## Window Opacity (Optional)

MaDev includes an optional installer for global Hyprland window opacity.

It applies consistent opacity settings to all application windows, without requiring individual window-class rules.

Default values:

- **Active windows:** 0.80 (80% opacity)
- **Inactive windows:** 0.75 (75% opacity)

The installer is not executed automatically during theme installation.

To enable the settings, run:

```bash
bash "$HOME/.config/omarchy/themes/madev/scripts/install-opacity.sh"
```

The installer:

- Adds a clearly marked MaDev configuration block to `~/.config/hypr/looknfeel.lua`.
- Creates a timestamped backup before modifying the file.
- Can be run again without adding duplicate settings.

Reload Hyprland if necessary:

```bash
hyprctl reload
```

These are global settings. They affect all Hyprland-managed application windows, not just browsers.

To change or remove the opacity settings, edit or remove the MaDev-managed block in:

```text
~/.config/hypr/looknfeel.lua
```

## Repository

**GitHub:** [https://github.com/manga-pannel-130/omarchy-madev-theme](https://github.com/manga-pannel-130/omarchy-madev-theme)

Contributions, suggestions, and feedback are welcome.

---

Made with care for the Omarchy community.
