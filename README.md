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
- **Screensaver**: 8 minutes (480s) - default is 2.5 minutes
- **Lock screen**: 8 minutes 1 second (481s)
- **Screen off**: 8 minutes 10 seconds (490s)

## Usage

### Fresh Install
```bash
git clone git@github.com:reisset/omarchyoverrides.git
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
        └── hypr/
            ├── bindings.conf
            └── hypridle.conf
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
