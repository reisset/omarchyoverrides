#!/bin/bash

# Omarchy Overrides Uninstaller
# Removes stow symlinks and restores default configs

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

print_header "Omarchy Overrides Uninstaller" "$CYAN"

# Unstow the package
log_info "Removing stow symlinks..."
cd "$REPO_DIR"
stow -v -D -t "$HOME" omarchy

# Restore Omarchy defaults (files must exist before Hyprland reloads)
log_info "Restoring Omarchy default configs..."
omarchy-refresh-config hypr/bindings.conf
omarchy-refresh-config hypr/hypridle.conf

# Reload Hyprland to pick up restored configs
log_info "Reloading Hyprland config..."
hyprctl reload

# Restart hypridle with default config
log_info "Restarting hypridle daemon..."
killall hypridle 2>/dev/null || true
hypridle > /dev/null 2>&1 &
disown
sleep 0.5

print_success_box "Uninstall Complete!"

log_info "Omarchy defaults have been restored."
echo ""
