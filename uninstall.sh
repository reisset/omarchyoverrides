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

print_success_box "Uninstall Complete!"

log_info "Symlinks removed. To restore Omarchy defaults, run:"
echo "  omarchy-refresh-config hypr/bindings.conf"
echo "  omarchy-refresh-config hypr/hypridle.conf"
echo ""
log_warn "Then restart hypridle:"
echo "  killall hypridle && hypridle &"
echo ""
