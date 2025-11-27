#!/bin/bash

# Just Fucking Linux Build Environment Setup
# Sets up everything needed to build JFL ISOs
# Version: 1.0.0
# Author: Just Fucking Linux Project

set -euo pipefail

# Configuration
JFL_VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# Messages
SETUP_MESSAGES=(
    "Setting up your JFL build environment..."
    "Preparing to build some fucking Linux..."
    "Configuring the tools of rebellion..."
    "Setting up the build pipeline..."
    "Initializing your JFL development environment..."
    "Preparing for ISO creation madness..."
    "Setting up the workshop of chaos..."
    "Configuring your Linux building station..."
    "Preparing the forge of freedom..."
    "Setting up tools for digital insurrection..."
)

# Print colored header
print_header() {
    echo -e "${RED}${BOLD}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}${BOLD}║${WHITE}              JFL Build Environment Setup                  ${RED}${BOLD}║${NC}"
    echo -e "${RED}${BOLD}║${WHITE}                        Version ${JFL_VERSION}                    ${RED}${BOLD}║${NC}"
    echo -e "${RED}${BOLD}╚══════════════════════════════════════════════════════════════╝${NC}"
}

# Print message
print_message() {
    local color="$1"
    local message="$2"
    echo -e "${color}JFL-SETUP: ${message}${NC}"
}

# Check if running on Arch
check_arch() {
    print_message "$BLUE" "Checking if running on Arch Linux..."
    
    if [[ ! -f /etc/arch-release ]] && [[ ! -f /etc/artix-release ]]; then
        print_message "$YELLOW" "Warning: This script is designed for Arch Linux."
        print_message "$YELLOW" "Some packages may not be available on other distributions."
        read -p "Continue anyway? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    print_message "$GREEN" "Arch-based distribution detected."
}

# Update system
update_system() {
    print_message "$BLUE" "Updating system packages..."
    
    if sudo pacman -Syu --noconfirm; then
        print_message "$GREEN" "System updated successfully."
    else
        print_message "$RED" "Failed to update system. Please update manually first."
        exit 1
    fi
}

# Install base packages
install_base_packages() {
    print_message "$BLUE" "Installing base build packages..."
    
    local base_packages=(
        "base-devel"
        "git"
        "archiso"
        "squashfs-tools"
        "libisoburn"
        "dosfstools"
        "mtools"
        "xorriso"
        "pacman-contrib"
        "namcap"
        "fakeroot"
        "gnupg"
        "expect"
        "edk2-ovmf"
        "qemu"
        "cdrtools"
    )
    
    if sudo pacman -S --needed --noconfirm "${base_packages[@]}"; then
        print_message "$GREEN" "Base packages installed."
    else
        print_message "$RED" "Failed to install base packages."
        exit 1
    fi
}

# Install theme development packages
install_theme_packages() {
    print_message "$BLUE" "Installing theme development packages..."
    
    local theme_packages=(
        "gtk-engine-murrine"
        "gtk-engines"
        "glib2-devel"
        "gdk-pixbuf2"
        "librsvg"
        "inkscape"
        "gimp"
        "imagemagick"
        "optipng"
        "python-gobject"
        "python-cairo"
    )
    
    if sudo pacman -S --needed --noconfirm "${theme_packages[@]}"; then
        print_message "$GREEN" "Theme packages installed."
    else
        print_message "$YELLOW" "Some theme packages may not be available."
    fi
}

# Install documentation tools
install_doc_packages() {
    print_message "$BLUE" "Installing documentation tools..."
    
    local doc_packages=(
        "pandoc"
        "markdown"
        "python3"
        "python-pip"
        "python-markdown"
        "python-yaml"
        "texlive-core"
        "texlive-latexextra"
    )
    
    if sudo pacman -S --needed --noconfirm "${doc_packages[@]}"; then
        print_message "$GREEN" "Documentation packages installed."
    else
        print_message "$YELLOW" "Some documentation packages may not be available."
    fi
}

# Install testing tools
install_test_packages() {
    print_message "$BLUE" "Installing testing tools..."
    
    local test_packages=(
        "virtualbox"
        "virtualbox-host-modules-arch"
        "vagrant"
        "libvirt"
        "virt-install"
        "virt-viewer"
        "bridge-utils"
        "dnsmasq"
    )
    
    if sudo pacman -S --needed --noconfirm "${test_packages[@]}"; then
        print_message "$GREEN" "Testing packages installed."
    else
        print_message "$YELLOW" "Some testing packages may not be available."
    fi
}

# Setup yay for AUR packages
setup_yay() {
    print_message "$BLUE" "Setting up yay for AUR packages..."
    
    if ! command -v yay &> /dev/null; then
        print_message "$YELLOW" "Installing yay from AUR..."
        
        # Create temp directory
        local temp_dir=$(mktemp -d)
        cd "$temp_dir"
        
        # Clone and build yay
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        
        # Cleanup
        cd "$PROJECT_ROOT"
        rm -rf "$temp_dir"
        
        print_message "$GREEN" "yay installed successfully."
    else
        print_message "$GREEN" "yay is already installed."
    fi
}

# Install AUR packages
install_aur_packages() {
    print_message "$BLUE" "Installing AUR packages..."
    
    local aur_packages=(
        "calamares"
        "calamares-config"
        "plymouth"
        "mkinitcpio-openswap"
        "arch-install-scripts-git"
    )
    
    for package in "${aur_packages[@]}"; do
        print_message "$YELLOW" "Installing $package from AUR..."
        if yay -S --needed --noconfirm "$package"; then
            print_message "$GREEN" "$package installed."
        else
            print_message "$YELLOW" "$package failed to install."
        fi
    done
}

# Setup build directories
setup_directories() {
    print_message "$BLUE" "Setting up build directories..."
    
    # Create main directories
    mkdir -p "$PROJECT_ROOT"/{work,out,packages,cache,repo}
    mkdir -p "$PROJECT_ROOT/repo"/{core,extra,community}
    mkdir -p "$PROJECT_ROOT/themes"/{budgie,gtk,icons,grub,plymouth,wallpapers}
    mkdir -p "$PROJECT_ROOT/configs"/{pacman,calamares,systemd}
    mkdir -p "$PROJECT_ROOT/docs"/{installation,troubleshooting}
    mkdir -p "$PROJECT_ROOT/scripts"/{build,install,test}
    
    # Set permissions
    chmod -R 755 "$PROJECT_ROOT"
    
    print_message "$GREEN" "Build directories created."
}

# Setup makepkg configuration
setup_makepkg() {
    print_message "$BLUE" "Configuring makepkg..."
    
    local makepkg_conf="$HOME/.makepkg.conf"
    
    # Backup existing config
    if [[ -f "$makepkg_conf" ]]; then
        cp "$makepkg_conf" "$makepkg_conf.backup.$(date +%Y%m%d)"
    fi
    
    # Create optimized makepkg.conf
    cat > "$makepkg_conf" << 'EOF'
# JFL Optimized makepkg Configuration

# Package destination
PKGDEST=$HOME/jfl-build/packages
SRCDEST=$HOME/jfl-build/sources
SRCPKGDEST=$HOME/jfl-build/srcpackages

# Build flags
MAKEFLAGS="-j$(nproc)"
CFLAGS="-march=native -O2 -pipe -fno-plt"
CXXFLAGS="-march=native -O2 -pipe -fno-plt"
LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now"

# Build environment
BUILDENV=(!distcc color ccache check !sign)
OPTIONS=(strip docs libtool staticlibs emptydirs zipman purge !upx !debug)

# Package integrity
CHECKSUMS=(sha256)
PKGEXT='.pkg.tar.zst'
SRCEXT='.src.tar.gz'

# Compression
COMPRESSZST=(zstd -c -T0 -18 -)
COMPRESSBZ2=(bzip2 -c -f)
COMPRESSGZ=(gzip -c -f n)
COMPRESSXZ=(xz -c -T0 -)
COMPRESSLRZ=(lrzip -q)
COMPRESSLZO=(lzop -q)
COMPRESSZ=(compress -c -f)

# GPG signing
GPGKEY=""
EOF
    
    # Create build directories in home
    mkdir -p "$HOME/jfl-build"/{packages,sources,srcpackages}
    
    print_message "$GREEN" "makepkg configured for JFL builds."
}

# Setup Git configuration
setup_git() {
    print_message "$BLUE" "Configuring Git..."
    
    # Set global git config if not already set
    if [[ -z $(git config --global user.name) ]]; then
        git config --global user.name "JFL Builder"
    fi
    
    if [[ -z $(git config --global user.email) ]]; then
        git config --global user.email "builder@justfuckinglinux.com"
    fi
    
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    
    print_message "$GREEN" "Git configured."
}

# Setup GPG for package signing
setup_gpg() {
    print_message "$BLUE" "Setting up GPG for package signing..."
    
    # Generate GPG key if none exists
    if ! gpg --list-secret-keys 2>/dev/null | grep -q "sec"; then
        print_message "$YELLOW" "Generating GPG key for package signing..."
        print_message "$YELLOW" "Use default options, set expiration to 2 years"
        
        # Generate key with default options
        gpg --batch --gen-key << EOF
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: JFL Builder
Name-Email: builder@justfuckinglinux.com
Expire-Date: 2y
%commit
EOF
        
        print_message "$GREEN" "GPG key generated."
    else
        print_message "$GREEN" "GPG key already exists."
    fi
    
    # Get key ID
    local key_id=$(gpg --list-secret-keys --keyid-format LONG | grep sec | awk '{print $2}' | cut -d'/' -f2)
    
    # Add to makepkg.conf
    if [[ -n "$key_id" ]]; then
        echo "GPGKEY=\"$key_id\"" >> "$HOME/.makepkg.conf"
        print_message "$GREEN" "GPG key configured for package signing."
    fi
}

# Setup virtualization
setup_virtualization() {
    print_message "$BLUE" "Setting up virtualization for testing..."
    
    # Load virtualization modules
    sudo modprobe kvm 2>/dev/null || true
    sudo modprobe kvm_intel 2>/dev/null || sudo modprobe kvm_amd 2>/dev/null || true
    
    # Add user to groups
    sudo usermod -a -G libvirt,kvm,vboxusers "$(whoami)" 2>/dev/null || true
    
    # Enable services
    sudo systemctl enable libvirtd 2>/dev/null || true
    sudo systemctl start libvirtd 2>/dev/null || true
    
    print_message "$GREEN" "Virtualization configured."
}

# Create build scripts
create_build_scripts() {
    print_message "$BLUE" "Creating helper build scripts..."
    
    # Create quick build script
    cat > "$PROJECT_ROOT/quick-build.sh" << 'EOF'
#!/bin/bash
# Quick JFL ISO build
cd "$(dirname "$0")/scripts/build"
./build-jfl-iso.sh "$@"
EOF
    
    # Create clean script
    cat > "$PROJECT_ROOT/clean.sh" << 'EOF'
#!/bin/bash
# Clean JFL build artifacts
echo "Cleaning JFL build artifacts..."
rm -rf work/
rm -rf out/*.iso*
echo "Done."
EOF
    
    # Create test script
    cat > "$PROJECT_ROOT/test-iso.sh" << 'EOF'
#!/bin/bash
# Test JFL ISO in QEMU
ISO_FILE=$(find out/ -name "*.iso" | head -1)
if [[ -f "$ISO_FILE" ]]; then
    echo "Testing $ISO_FILE..."
    qemu-system-x86_64 -m 2048 -enable-kvm -cdrom "$ISO_FILE" -boot d
else
    echo "No ISO file found in out/"
fi
EOF
    
    # Make scripts executable
    chmod +x "$PROJECT_ROOT/quick-build.sh"
    chmod +x "$PROJECT_ROOT/clean.sh"
    chmod +x "$PROJECT_ROOT/test-iso.sh"
    
    print_message "$GREEN" "Helper scripts created."
}

# Setup environment variables
setup_environment() {
    print_message "$BLUE" "Setting up environment variables..."
    
    # Add to .bashrc if not already there
    local bashrc="$HOME/.bashrc"
    local jfl_env="# JFL Build Environment
export JFL_BUILD_ROOT=\"$PROJECT_ROOT\"
export JFL_WORK_DIR=\"$PROJECT_ROOT/work\"
export JFL_OUT_DIR=\"$PROJECT_ROOT/out\"
export JFL_REPO_DIR=\"$PROJECT_ROOT/repo\"
export PATH=\"\$PATH:\$JFL_BUILD_ROOT/scripts/build:\$JFL_BUILD_ROOT/scripts/install\"
"
    
    if ! grep -q "JFL Build Environment" "$bashrc"; then
        echo "" >> "$bashrc"
        echo "$jfl_env" >> "$bashrc"
        print_message "$GREEN" "Environment variables added to .bashrc"
    else
        print_message "$GREEN" "Environment variables already configured."
    fi
}

# Verify setup
verify_setup() {
    print_message "$BLUE" "Verifying setup..."
    
    local errors=0
    
    # Check required commands
    local required_commands=("pacman" "git" "mkarchiso" "xorriso" "qemu-system-x86_64")
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            print_message "$RED" "Missing command: $cmd"
            ((errors++))
        fi
    done
    
    # Check directories
    local required_dirs=("$PROJECT_ROOT/work" "$PROJECT_ROOT/out" "$PROJECT_ROOT/packages")
    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            print_message "$RED" "Missing directory: $dir"
            ((errors++))
        fi
    done
    
    # Check files
    local required_files=("$PROJECT_ROOT/scripts/build/build-jfl-iso.sh" "$HOME/.makepkg.conf")
    for file in "${required_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            print_message "$RED" "Missing file: $file"
            ((errors++))
        fi
    done
    
    if [[ $errors -eq 0 ]]; then
        print_message "$GREEN" "Setup verification passed!"
        return 0
    else
        print_message "$RED" "Setup verification failed with $errors errors."
        return 1
    fi
}

# Show next steps
show_next_steps() {
    print_message "$BLUE" "Setup completed! Next steps:"
    echo
    echo -e "${WHITE}1. Build your first JFL ISO:${NC}"
    echo -e "   ${CYAN}cd $PROJECT_ROOT${NC}"
    echo -e "   ${CYAN}./quick-build.sh${NC}"
    echo
    echo -e "${WHITE}2. Test the ISO:${NC}"
    echo -e "   ${CYAN}./test-iso.sh${NC}"
    echo
    echo -e "${WHITE}3. Clean build artifacts:${NC}"
    echo -e "   ${CYAN}./clean.sh${NC}"
    echo
    echo -e "${WHITE}4. Customize themes and packages:${NC}"
    echo -e "   ${CYAN}Edit files in themes/ and packages/ directories${NC}"
    echo
    echo -e "${WHITE}5. Build with options:${NC}"
    echo -e "   ${CYAN}./quick-build.sh --skip-test${NC}    # Skip QEMU testing"
    echo -e "   ${CYAN}./quick-build.sh --test-only${NC}    # Only test existing ISO"
    echo
    print_message "$GREEN" "Your JFL build environment is ready!"
    print_message "$YELLOW" "Go build some fucking Linux!"
}

# Main function
main() {
    print_header
    echo
    
    print_message "$YELLOW" "$(get_random_message "${SETUP_MESSAGES[@]}")"
    echo
    
    # Parse command line arguments
    local skip_update=false
    local minimal=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --skip-update)
                skip_update=true
                shift
                ;;
            --minimal)
                minimal=true
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [options]"
                echo "Options:"
                echo "  --skip-update    Skip system update"
                echo "  --minimal        Install minimal packages only"
                echo "  --help, -h       Show this help"
                exit 0
                ;;
            *)
                print_message "$RED" "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Run setup steps
    check_arch
    
    if [[ "$skip_update" != true ]]; then
        update_system
    fi
    
    install_base_packages
    
    if [[ "$minimal" != true ]]; then
        install_theme_packages
        install_doc_packages
        install_test_packages
        setup_yay
        install_aur_packages
        setup_virtualization
    fi
    
    setup_directories
    setup_makepkg
    setup_git
    setup_gpg
    create_build_scripts
    setup_environment
    
    if verify_setup; then
        show_next_steps
    else
        print_message "$RED" "Setup verification failed. Please check the errors above."
        exit 1
    fi
}

# Run main function
main "$@"
