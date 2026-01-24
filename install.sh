#!/bin/bash

# Omarchy Overrides Installer
# Applies custom keybindings and idle settings via GNU Stow

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print a boxed header message
print_header() {
    local msg="$1"
    local color="${2:-$CYAN}"
    local width=55
    local pad=$(( (width - ${#msg}) / 2 ))
    echo ""
    echo -e "${color}╔$(printf '═%.0s' $(seq 1 $width))╗${NC}"
    echo -e "${color}║$(printf ' %.0s' $(seq 1 $pad))${msg}$(printf ' %.0s' $(seq 1 $((width - pad - ${#msg}))))║${NC}"
    echo -e "${color}╚$(printf '═%.0s' $(seq 1 $width))╝${NC}"
    echo ""
}

print_success_box() {
    local msg="$1"
    print_header "$msg" "$GREEN"
}

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

print_header "Omarchy Overrides Installer" "$CYAN"

# Check for stow
if ! command -v stow &> /dev/null; then
    log_warn "GNU Stow not found. Installing..."
    if command -v yay &> /dev/null; then
        yay -S --noconfirm stow
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm stow
    else
        echo "Please install GNU Stow manually and re-run this script."
        exit 1
    fi
fi

# Install Brave browser if not present
if ! command -v brave &> /dev/null && ! command -v brave-browser &> /dev/null; then
    log_info "Installing Brave browser..."
    curl -fsS https://dl.brave.com/install.sh | sh
else
    log_info "Brave browser already installed, skipping..."
fi

# Backup existing configs
log_info "Backing up existing configs..."
BACKUP_DIR="$HOME/.config/omarchy-overrides-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR/hypr" "$BACKUP_DIR/waybar"

# Backup hypr configs
if [ -f "$HOME/.config/hypr/bindings.conf" ] && [ ! -L "$HOME/.config/hypr/bindings.conf" ]; then
    cp "$HOME/.config/hypr/bindings.conf" "$BACKUP_DIR/hypr/"
    log_info "Backed up hypr/bindings.conf"
fi

if [ -f "$HOME/.config/hypr/hypridle.conf" ] && [ ! -L "$HOME/.config/hypr/hypridle.conf" ]; then
    cp "$HOME/.config/hypr/hypridle.conf" "$BACKUP_DIR/hypr/"
    log_info "Backed up hypr/hypridle.conf"
fi

if [ -f "$HOME/.config/hypr/looknfeel.conf" ] && [ ! -L "$HOME/.config/hypr/looknfeel.conf" ]; then
    cp "$HOME/.config/hypr/looknfeel.conf" "$BACKUP_DIR/hypr/"
    log_info "Backed up hypr/looknfeel.conf"
fi

# Backup waybar configs
if [ -f "$HOME/.config/waybar/config.jsonc" ] && [ ! -L "$HOME/.config/waybar/config.jsonc" ]; then
    cp "$HOME/.config/waybar/config.jsonc" "$BACKUP_DIR/waybar/"
    log_info "Backed up waybar/config.jsonc"
fi

if [ -f "$HOME/.config/waybar/style.css" ] && [ ! -L "$HOME/.config/waybar/style.css" ]; then
    cp "$HOME/.config/waybar/style.css" "$BACKUP_DIR/waybar/"
    log_info "Backed up waybar/style.css"
fi

log_info "Backups saved to: $BACKUP_DIR"

# Remove existing files (stow needs the target to not exist)
rm -f "$HOME/.config/hypr/bindings.conf"
rm -f "$HOME/.config/hypr/hypridle.conf"
rm -f "$HOME/.config/hypr/looknfeel.conf"
rm -f "$HOME/.config/waybar/config.jsonc"
rm -f "$HOME/.config/waybar/style.css"

# Stow the package
log_info "Stowing omarchy overrides..."
cd "$REPO_DIR"
stow -v -t "$HOME" omarchy

# Reload Hyprland to pick up new bindings (symlinks don't trigger auto-reload)
log_info "Reloading Hyprland config..."
hyprctl reload

# Restart hypridle to apply new timeout settings
log_info "Restarting hypridle daemon..."
killall hypridle 2>/dev/null || true
hypridle > /dev/null 2>&1 &
disown

# Restart waybar to apply new styling
log_info "Restarting waybar..."
killall waybar 2>/dev/null || true
waybar > /dev/null 2>&1 &
disown
sleep 0.5  # Let services initialize before printing

print_success_box "Installation Complete!"

log_info "Your overrides are now active:"
echo "  - Keybindings: SUPER+Q close, custom app launchers"
echo "  - Idle timeout: 5 min screensaver, 10 min lock, 15 min screen off"
echo "  - Waybar: scaled up (height 30, icons 19px, text 14px)"
echo "  - Performance: blur off, shadows off, VFR enabled"
echo ""
log_warn "Don't forget to visit omarchy-cleaner for package removal:"
echo "  https://github.com/maxart/omarchy-cleaner"
echo ""
