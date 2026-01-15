# Omarchy Overrides

Custom configurations for [Omarchy](https://omarchy.org/), the beautiful Arch Linux Hyprland rice. Managed with GNU Stow.

## What's Included

### Keybindings (`bindings.conf`)
- `SUPER + Q` - Close window (instead of default SUPER + W)
- `SUPER + RETURN` - Terminal
- `SUPER SHIFT + F` - File manager (Nautilus)
- `SUPER SHIFT + B` - Browser
- `SUPER SHIFT + M` - Music (Spotify)
- `SUPER SHIFT + G` - Signal
- `SUPER SHIFT + O` - Obsidian
- `SUPER SHIFT + W` - Typora
- `SUPER SHIFT + Y` - YouTube
- `SUPER SHIFT + X` - X (Twitter)
- `SUPER SHIFT ALT + A` - Grok

### Idle Settings (`hypridle.conf`)
- **Screensaver**: 5 minutes (300s)
- **Lock screen**: 10 minutes (600s)
- **Screen off**: 15 minutes (900s)

### Waybar (`waybar/`)
- **Scaled up**: bar height 30, global font 14px, status icons 19px, tray icons 16px

## Usage

### Fresh Install
```bash
git clone https://github.com/reisset/omarchyoverrides.git
cd omarchyoverrides
./install.sh
```

### Uninstall
```bash
./uninstall.sh
```

### Manual Restore to Defaults
```bash
omarchy-refresh-config hypr/bindings.conf
omarchy-refresh-config hypr/hypridle.conf
killall hypridle && hypridle &
```

## Structure

```
omarchyoverrides/
├── README.md
├── install.sh
├── uninstall.sh
└── omarchy/              # GNU Stow package
    └── .config/
        ├── hypr/
        │   ├── bindings.conf
        │   └── hypridle.conf
        └── waybar/
            ├── config.jsonc
            └── style.css
```

## Extending

### Add Waybar Customization
Create the waybar config directory and add your files:
```
omarchy/.config/waybar/
├── config.jsonc
└── style.css
```
Then re-run `./install.sh` to stow the new configs.

## Package Removal

For removing unwanted Omarchy packages, use [omarchy-cleaner](https://github.com/maxart/omarchy-cleaner).
