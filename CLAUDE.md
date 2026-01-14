# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

GNU Stow-based configuration overrides for [Omarchy](https://omarchy.org/) (Arch Linux Hyprland rice). Symlinks custom configs into `~/.config/` to override Omarchy defaults while keeping overrides version-controlled.

## Commands

```bash
# Install overrides (stows configs, reloads Hyprland, restarts hypridle)
./install.sh

# Uninstall overrides (unstows, restores Omarchy defaults)
./uninstall.sh

# Manually restore a single config to Omarchy default
omarchy-refresh-config hypr/bindings.conf
```

## Architecture

```
omarchy/                    # Stow package - mirrors ~/.config structure
└── .config/
    └── hypr/
        ├── bindings.conf   # Keybindings (SUPER+Q close, app launchers)
        └── hypridle.conf   # Idle timeouts (5/10/15 min)
```

Stow creates symlinks: `~/.config/hypr/bindings.conf` → `repo/omarchy/.config/hypr/bindings.conf`

## Adding New Overrides

1. Create the file at `omarchy/.config/<app>/<file>` (mirroring the `~/.config` path)
2. Run `./install.sh` to stow the new config
3. Hyprland auto-reloads most configs; for other apps, restart them manually

## Key Details

- `install.sh` backs up existing configs to `~/.config/hypr/backup-<timestamp>/` before stowing
- After stowing, scripts reload Hyprland (`hyprctl reload`) and restart hypridle
- Hyprland config uses `bindd` (with description) and `unbind` to override default bindings
- hypridle listeners are ordered by timeout (screensaver → lock → screen off)
