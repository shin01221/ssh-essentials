#!/bin/bash

set -euo pipefail

#==============================================================================
# CONFIGURATION
#==============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
readonly CONFIG_DIR="${HOME}/.config"
readonly FONT_DIR="${HOME}/.local/share/fonts"

#==============================================================================
# COLORS
#==============================================================================
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

#==============================================================================
# GLOBAL VARIABLES
#==============================================================================
PACKAGE_MANAGER=""
PRIVILEGE_CMD=""

#==============================================================================
# LOGGING FUNCTIONS
#==============================================================================
log_info() {
    printf "${BLUE}[INFO]${NC} %s\n" "$1"
}

log_success() {
    printf "${GREEN}[SUCCESS]${NC} %s\n" "$1"
}

log_warning() {
    printf "${YELLOW}[WARNING]${NC} %s\n" "$1"
}

log_error() {
    printf "${RED}[ERROR]${NC} %s\n" "$1" >&2
}

#==============================================================================
# UTILITY FUNCTIONS
#==============================================================================
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

get_user_home() {
    if [ -n "${SUDO_USER:-}" ]; then
        getent passwd "$SUDO_USER" | cut -d: -f6
    else
        echo "$HOME"
    fi
}

#==============================================================================
# SYSTEM DETECTION
#==============================================================================
detect_package_manager() {
    local managers="nala apt dnf yum pacman zypper emerge xbps-install nix-env"

    for manager in $managers; do
        if command_exists "$manager"; then
            PACKAGE_MANAGER="$manager"
            log_info "Detected package manager: $manager"
            return 0
        fi
    done

    log_error "No supported package manager found"
    return 1
}

detect_privilege_escalation() {
    if command_exists sudo; then
        PRIVILEGE_CMD="sudo"
    elif command_exists doas && [ -f "/etc/doas.conf" ]; then
        PRIVILEGE_CMD="doas"
    else
        PRIVILEGE_CMD="su -c"
    fi
    log_info "Using privilege escalation: $PRIVILEGE_CMD"
}

#==============================================================================
# VALIDATION FUNCTIONS
#==============================================================================
validate_requirements() {
    local requirements="curl git"
    local missing=""

    for req in $requirements; do
        if ! command_exists "$req"; then
            missing="$missing $req"
        fi
    done

    if [ -n "$missing" ]; then
        log_error "Missing required commands:$missing"
        return 1
    fi

    return 0
}

validate_permissions() {
    if ! groups | grep -qE "(wheel|sudo|root)"; then
        log_warning "User not in wheel/sudo/root; operations may prompt for password."
    fi

    if [ ! -w "$SCRIPT_DIR" ]; then
        log_warning "No write permission to script directory: $SCRIPT_DIR (continuing)"
    fi

    return 0
}

#==============================================================================
# SETUP FUNCTIONS
#==============================================================================
setup_directories() {
    log_info "Setting up directories..."

    mkdir -p "$CONFIG_DIR" "$FONT_DIR"

    log_info "Working from current directory: $SCRIPT_DIR"
}

#==============================================================================
# INSTALLATION FUNCTIONS
#==============================================================================
install_packages() {
    local packages=(bash bash-completion tar bat tree multitail wget unzip fontconfig ripgrep fd)
    if ! command_exists nvim; then
        packages+=(neovim)
    fi
    if ! command_exists trash; then
        packages+=(trash-cli)
    fi

    log_info "Installing packages: ${packages[*]}"

    case "$PACKAGE_MANAGER" in
    pacman)
        $PRIVILEGE_CMD pacman -Syu --needed --noconfirm "${packages[@]}"
        ;;
    nala | apt)
        $PRIVILEGE_CMD "$PACKAGE_MANAGER" update
        $PRIVILEGE_CMD "$PACKAGE_MANAGER" install -y "${packages[@]}"
        ;;
    dnf | yum)
        $PRIVILEGE_CMD "$PACKAGE_MANAGER" install -y "${packages[@]}"
        $PRIVILEGE_CMD "$PACKAGE_MANAGER" install -y fd-find
        ;;
    emerge)
        local emerge_packages=(app-shells/bash-completion app-arch/tar sys-apps/bat app-text/tree app-text/multitail app-misc/trash-cli)
        if ! command_exists nvim; then
            emerge_packages+=(app-editors/neovim)
        fi
        $PRIVILEGE_CMD "$PACKAGE_MANAGER" -v --noreplace "${emerge_packages[@]}"
        ;;
    xbps-install)
        $PRIVILEGE_CMD "$PACKAGE_MANAGER" -Sy "${packages[@]}"
        ;;
    nix-env)
        local nix_packages=(nixpkgs.bash nixpkgs.bash-completion nixpkgs.gnutar nixpkgs.bat nixpkgs.tree nixpkgs.multitail nixpkgs.trash-cli)
        if ! command_exists nvim; then
            nix_packages+=(nixpkgs.neovim)
        fi
        nix-env -iA "${nix_packages[@]}"
        ;;
    zypper)
        $PRIVILEGE_CMD "$PACKAGE_MANAGER" install -y "${packages[@]}"
        ;;
    *)
        log_error "Unsupported package manager: $PACKAGE_MANAGER"
        return 1
        ;;
    esac
}

install_nerd_font() {
    local font_name="MesloLGS Nerd Font"

    if fc-list | grep -qi "meslo"; then
        log_info "Nerd font already installed"
        return 0
    fi

    log_info "Installing $font_name..."

    local font_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
    local temp_dir
    temp_dir=$(mktemp -d)

    if wget -q "$font_url" -O "$temp_dir/Meslo.zip"; then
        unzip -q "$temp_dir/Meslo.zip" -d "$temp_dir"
        mkdir -p "$FONT_DIR/MesloLGS"
        find "$temp_dir" -name "*.ttf" -exec mv {} "$FONT_DIR/MesloLGS/" \;
        fc-cache -fv >/dev/null 2>&1
        log_success "Font installed successfully"
    else
        log_warning "Failed to download font"
    fi

    rm -rf "$temp_dir"
}

install_starship() {
    if command_exists starship; then
        log_info "Starship already installed"
        return 0
    fi

    log_info "Installing Starship prompt..."
    if curl -sS https://starship.rs/install.sh | sh -s -- -y; then
        log_success "Starship installed successfully"
    else
        log_error "Failed to install Starship"
        return 1
    fi
}

install_fzf() {
    if command_exists fzf; then
        log_info "FZF already installed"
        return 0
    fi

    local fzf_dir="$HOME/.fzf"

    if [ -d "$fzf_dir" ]; then
        log_info "FZF directory exists, updating..."
        cd "$fzf_dir" && git pull
    else
        log_info "Installing FZF..."
        git clone --depth 1 https://github.com/junegunn/fzf.git "$fzf_dir"
    fi

    "$fzf_dir/install" --all --no-update-rc
    log_success "FZF installed successfully"
}

install_zoxide() {
    if command_exists zoxide; then
        log_info "Zoxide already installed"
        return 0
    fi

    log_info "Installing Zoxide..."
    if curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh; then
        log_success "Zoxide installed successfully"
    else
        log_error "Failed to install Zoxide"
        return 1
    fi
}

#==============================================================================
# CONFIGURATION FUNCTIONS
#==============================================================================

setup_bash_config() {
    local user_home
    user_home=$(get_user_home)
    local bashrc="$user_home/.bashrc"
    local bash_profile="$user_home/.bash_profile"
    local starship_config="$user_home/.config/starship.toml"

    # Backup existing bashrc if it's a regular file and not a symlink
    if [ -f "$bashrc" ] && [ ! -L "$bashrc" ]; then
        log_info "Backing up existing .bashrc"
        mv "$bashrc" "$bashrc.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    # Link new configurations
    if [ -f "$SCRIPT_DIR/.bashrc" ]; then
        ln -sf "$SCRIPT_DIR/.bashrc" "$bashrc"
        log_success "Bashrc configuration linked"
    else
        log_warning "Bashrc template not found; creating a minimal .bashrc"
        cat >"$bashrc" <<'EOF'
# Minimal .bashrc created by mybash setup
export PATH="$HOME/.local/bin:$PATH"
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi
EOF
    fi

    if [ -f "$SCRIPT_DIR/starship.toml" ]; then
        ln -sf "$SCRIPT_DIR/starship.toml" "$starship_config"
        log_success "Starship configuration linked"
    else
        log_warning "Starship config template not found"
    fi

    # Create bash_profile if needed
    if [ ! -f "$bash_profile" ]; then
        cat >"$bash_profile" <<'EOF'
# Source bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
EOF
        log_success "Created .bash_profile"
    fi
}

cleanup_project_files() {
    log_info "Cleaning up project files..."

    # Remove git directory
    if [ -d "$SCRIPT_DIR/.git" ]; then
        rm -rf "$SCRIPT_DIR/.git"
        log_success "Removed .git directory"
    fi

    # Remove vscode directory
    if [ -d "$SCRIPT_DIR/.vscode" ]; then
        rm -rf "$SCRIPT_DIR/.vscode"
        log_success "Removed .vscode directory"
    fi

    # Remove gitignore file
    if [ -f "$SCRIPT_DIR/.gitignore" ]; then
        rm -f "$SCRIPT_DIR/.gitignore"
        log_success "Removed .gitignore file"
    fi

    # Remove README file
    if [ -f "$SCRIPT_DIR/README.md" ]; then
        rm -f "$SCRIPT_DIR/README.md"
        log_success "Removed README.md file"
    fi

    log_success "Project cleanup completed"
}

#==============================================================================
# MAIN EXECUTION
#==============================================================================
main() {
    log_info "Starting Linux Toolbox setup..."

    # Validation phase
    validate_requirements || exit 1
    validate_permissions || exit 1

    # Detection phase
    detect_package_manager || exit 1
    detect_privilege_escalation

    # Setup phase
    setup_directories || exit 1

    # Installation phase
    install_packages || exit 1
    install_nerd_font
    install_starship || exit 1
    install_fzf || exit 1
    install_zoxide || exit 1

    # Configuration phase
    setup_bash_config || exit 1

    # Cleanup phase
    cleanup_project_files

    log_success "Setup completed successfully!"
    log_info "Please restart your shell or run 'source ~/.bashrc' to apply changes"
}

# Run main function
main "$@"
bash ./tmux-setup.sh
bash ./nvim-setup.sh
