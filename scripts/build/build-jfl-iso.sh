#!/bin/bash

# Just Fucking Linux ISO Build Script
# Builds a complete JFL distribution ISO from scratch
# Version: 1.0.0
# Author: Just Fucking Linux Project

set -euo pipefail

# Configuration
JFL_VERSION="1.0.0"
JFL_RELEASE_DATE=$(date +%Y%m%d)
JFL_NAME="jfl-${JFL_RELEASE_DATE}-x86_64"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
WORK_DIR="${PROJECT_ROOT}/work"
OUT_DIR="${PROJECT_ROOT}/out"
PROFILE_DIR="${PROJECT_ROOT}/iso-profile"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36c'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# Messages
MESSAGES=(
    "Time to build some fucking Linux."
    "Let's create this monstrosity."
    "Building ISO: pray to the build gods."
    "Compiling the essence of sarcasm."
    "Forging a new Linux distribution."
    "Assembling digital awesomeness."
    "Creating the ultimate anti-establishment OS."
    "Building Linux with attitude."
    "Compiling rebellion into an ISO."
    "Forging freedom in binary form."
)

SUCCESS_MESSAGES=(
    "Holy shit, the ISO built successfully!"
    "Against all odds, it actually worked!"
    "ISO creation complete. Don't fuck it up now."
    "Build successful. The Linux gods are pleased."
    "Mission accomplished. Your ISO awaits."
    "Build complete. Now go break it in a VM."
    "Success! You have created JFL magic."
    "ISO built. The world is not ready."
    "Build finished. Time to spread the chaos."
    "Complete. Your JFL ISO is ready for deployment."
)

ERROR_MESSAGES=(
    "Well, that build went to shit."
    "Build failed. Shocking, I know."
    "Congratulations, you broke the build."
    "Build failed. Check your dependencies."
    "The build gods are angry with you."
    "Build failed spectacularly. Classic."
    "Error achieved. You must be proud."
    "Build failed. Time to debug your life choices."
    "Compilation catastrophe. Try again."
    "Build failed. The ISO is not ready for your fuckery."
)

# Print colored header
print_header() {
    echo -e "${RED}${BOLD}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}${BOLD}║${WHITE}                Just Fucking Linux ISO Builder               ${RED}${BOLD}║${NC}"
    echo -e "${RED}${BOLD}║${WHITE}                        Version ${JFL_VERSION}                    ${RED}${BOLD}║${NC}"
    echo -e "${RED}${BOLD}╚══════════════════════════════════════════════════════════════╝${NC}"
}

# Print message
print_message() {
    local color="$1"
    local message="$2"
    echo -e "${color}JFL-BUILD: ${message}${NC}"
}

# Print random message
print_random_message() {
    local messages=("$@")
    echo -e "${YELLOW}JFL-BUILD: ${messages[$RANDOM % ${#messages[@]}]}${NC}"
}

# Check dependencies
check_dependencies() {
    print_message "$BLUE" "Checking build dependencies..."
    
    local missing_deps=()
    local required_deps=(
        "archiso"
        "git"
        "squashfs-tools"
        "libisoburn"
        "dosfstools"
        "mtools"
        "xorriso"
        "pacman"
        "sed"
        "awk"
        "grep"
        "find"
        "tar"
        "gzip"
    )
    
    for dep in "${required_deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_message "$RED" "Missing dependencies: ${missing_deps[*]}"
        print_message "$YELLOW" "Install them with: sudo pacman -S ${missing_deps[*]}"
        exit 1
    fi
    
    print_message "$GREEN" "All dependencies satisfied."
}

# Setup directories
setup_directories() {
    print_message "$BLUE" "Setting up build directories..."
    
    # Clean previous builds
    if [[ -d "$WORK_DIR" ]]; then
        print_message "$YELLOW" "Cleaning previous build..."
        rm -rf "$WORK_DIR"
    fi
    
    if [[ -d "$OUT_DIR" ]]; then
        mkdir -p "$OUT_DIR"
    fi
    
    # Create work directories
    mkdir -p "$WORK_DIR"/{airootfs,x86_64,efiboot}
    mkdir -p "$OUT_DIR"
    
    print_message "$GREEN" "Directories created."
}

# Copy profile files
copy_profile() {
    print_message "$BLUE" "Copying archiso profile..."
    
    # Copy base profile
    cp -r /usr/share/archiso/configs/releng/* "$PROFILE_DIR/"
    
    # Remove default packages.x86_64
    rm -f "$PROFILE_DIR/packages.x86_64"
    
    print_message "$GREEN" "Profile copied."
}

# Create package list
create_package_list() {
    print_message "$BLUE" "Creating JFL package list..."
    
    cat > "$PROFILE_DIR/packages.x86_64" << 'EOF'
# JFL Base System
base
linux
linux-firmware
systemd
pacman
archlinux-keyring

# JFL Branding and Tools
jfl-core-branding
fucking
just

# Display Server
xorg-server
xorg-xinit
mesa
libgl-mesa
vulkan-radeon
vulkan-intel
vulkan-nvidia

# Desktop Environment
budgie-desktop
budgie-desktop-view
budgie-screensaver
budgie-control-center
gnome-session
gnome-settings-daemon

# Display Manager
gdm

# Audio
pipewire
pipewire-pulse
wireplumber
alsa-utils
pavucontrol

# Network
networkmanager
network-manager-applet
nm-connection-editor
bluez
bluez-utils
blueman

# Themes and Appearance
jfl-budgie-theme
jfl-gtk-theme
jfl-icon-theme
jfl-grub-theme
jfl-plymouth-theme
gtk-engine-murrine
gtk-engines

# Fonts
ttf-hack
ttf-inter
ttf-bebas-neue
noto-fonts
noto-fonts-emoji

# Core Applications
firefox
libreoffice-fresh
geary
vlc
rhythmbox
gimp
inkscape
gnome-terminal
nautilus
gnome-calculator
gnome-text-editor
gnome-screenshot
eog
evince
gnome-disk-utility
gnome-system-monitor
baobab

# Development Tools
code
git
gcc
make
cmake
python
nodejs
npm
yay

# System Utilities
htop
neofetch
screenfetch
tree
wget
curl
unzip
zip
p7zip
gparted
timeshift
grub-customizer
firmware-manager

# Installer
calamares

# Boot and Firmware
efibootmgr
dosfstools
gptfdisk

# Archive Tools
unrar
p7zip
zip
unzip
EOF
    
    print_message "$GREEN" "Package list created with $(wc -l < "$PROFILE_DIR/packages.x86_64") packages."
}

# Configure pacman
configure_pacman() {
    print_message "$BLUE" "Configuring pacman..."
    
    cat > "$PROFILE_DIR/pacman.conf" << 'EOF'
[options]
HoldPkg     = pacman glibc
Architecture = auto

CheckSpace
SigLevel    = Required DatabaseOptional
LocalFileSigLevel = Optional

[core]
Server = https://mirrors.archlinux.org/$repo/os/$arch

[extra]
Server = https://mirrors.archlinux.org/$repo/os/$arch

[community]
Server = https://mirrors.archlinux.org/$repo/os/$arch

[multilib]
Include = /etc/pacman.d/mirrorlist
EOF
    
    print_message "$GREEN" "Pacman configured."
}

# Create custom files
create_custom_files() {
    print_message "$BLUE" "Creating JFL custom files..."
    
    # Create JFL branding directory
    mkdir -p "$PROFILE_DIR/airootfs/etc/jfl"
    
    # JFL release info
    cat > "$PROFILE_DIR/airootfs/etc/jfl/release" << EOF
Just Fucking Linux $JFL_VERSION
Build Date: $(date)
Kernel: $(uname -r)
Desktop: Budgie with JFL Theme
Package Manager: fucking (pacman wrapper)
EOF
    
    # JFL MOTD
    cat > "$PROFILE_DIR/airootfs/etc/jfl/motd" << 'EOF'
Welcome to Just Fucking Linux!

The distribution that tells you what it really thinks.
No hand-holding, no bullshit, just powerful Linux.

Quick start:
  just fucking install <package>    - Install software
  just fucking upgrade              - Update system
  jfl-welcome                       - First-time setup

Remember: If you break it, you get to keep both pieces.

Enjoy the rebellion,
- The JFL Team
EOF
    
    # Copy JFL tools
    cp "$PROJECT_ROOT/packages/jfl-tools/fucking" "$PROFILE_DIR/airootfs/usr/bin/"
    cp "$PROJECT_ROOT/packages/jfl-tools/just" "$PROFILE_DIR/airootfs/usr/bin/"
    chmod +x "$PROFILE_DIR/airootfs/usr/bin/fucking"
    chmod +x "$PROFILE_DIR/airootfs/usr/bin/just"
    
    # Create sudoers entry for just
    mkdir -p "$PROFILE_DIR/airootfs/etc/sudoers.d"
    echo "ALL ALL=(ALL) NOPASSWD: /usr/bin/just" > "$PROFILE_DIR/airootfs/etc/sudoers.d/jfl"
    
    print_message "$GREEN" "Custom files created."
}

# Configure system services
configure_services() {
    print_message "$BLUE" "Configuring system services..."
    
    # Enable services
    mkdir -p "$PROFILE_DIR/airootfs/etc/systemd/system/multi-user.target.wants"
    mkdir -p "$PROFILE_DIR/airootfs/etc/systemd/system/graphical.target.wants"
    
    # Enable essential services
    ln -sf /usr/lib/systemd/system/NetworkManager.service "$PROFILE_DIR/airootfs/etc/systemd/system/multi-user.target.wants/NetworkManager.service"
    ln -sf /usr/lib/systemd/system/gdm.service "$PROFILE_DIR/airootfs/etc/systemd/system/graphical.target.wants/gdm.service"
    ln -sf /usr/lib/systemd/system/bluetooth.service "$PROFILE_DIR/airootfs/etc/systemd/system/multi-user.target.wants/bluetooth.service"
    
    print_message "$GREEN" "Services configured."
}

# Create desktop configuration
configure_desktop() {
    print_message "$BLUE" "Configuring Budgie desktop..."
    
    # Create user directories
    mkdir -p "$PROFILE_DIR/airootfs/etc/skel"/{Desktop,Documents,Downloads,Music,Pictures,Videos,Templates}
    
    # Set default GTK theme
    mkdir -p "$PROFILE_DIR/airootfs/etc/skel/.config/gtk-3.0"
    cat > "$PROFILE_DIR/airootfs/etc/skel/.config/gtk-3.0/settings.ini" << EOF
[Settings]
gtk-theme-name=JFL-Budgie
gtk-icon-theme-name=JFL-Icons
gtk-font-name=Hack 11
gtk-cursor-theme-name=Adwaita
gtk-application-prefer-dark-theme=true
EOF
    
    # Create Budgie settings
    mkdir -p "$PROFILE_DIR/airootfs/etc/skel/.config/budgie-desktop"
    cat > "$PROFILE_DIR/airootfs/etc/skel/.config/budgie-desktop/session.conf" << EOF
[Budgie Session]
primary-monitor=0
EOF
    
    print_message "$GREEN" "Desktop configured."
}

# Create installer configuration
configure_installer() {
    print_message "$BLUE" "Configuring Calamares installer..."
    
    mkdir -p "$PROFILE_DIR/airootfs/etc/calamares"
    
    # Basic Calamares configuration
    cat > "$PROFILE_DIR/airootfs/etc/calamares/settings.conf" << EOF
modules-search: [ local ]

instances:
- id: after
  module: shellprocess
  config: shellprocess_after.conf
  weight: 70
- id: before
  module: shellprocess
  config: shellprocess_before.conf
  weight: 70

sequence:
- show:
  - welcome
  - locale
  - keyboard
  - partition
  - users
  - summary
- exec:
  - partition
  - mount
  - unpackfs
  - machineid
  - fstab
  - locale
  - keyboard
  - localecfg
  - users
  - displaymanager
  - networkcfg
  - hwclock
  - services-systemd
  - shellprocess@before
  - packages
  - grubcfg
  - initcpiocfg
  - initcpio
  - removeuser
  - shellprocess@after
- show:
  - finished

branding: jfl

prompt-install: false
dont-chroot: false
oem-setup: false
disable-cancel: false
disable-cancel-during-exec: false
hide-back-and-next-during-exec: false
quit-at-end: false
EOF
    
    print_message "$GREEN" "Installer configured."
}

# Build the ISO
build_iso() {
    print_message "$BLUE" "Building JFL ISO..."
    print_random_message "${MESSAGES[@]}"
    
    cd "$PROFILE_DIR"
    
    # Run mkarchiso
    if sudo mkarchiso -v -w "$WORK_DIR" -d "$OUT_DIR" "$PROFILE_DIR"; then
        print_message "$GREEN" "$(get_random_message "${SUCCESS_MESSAGES[@]}")"
        return 0
    else
        print_message "$RED" "$(get_random_message "${ERROR_MESSAGES[@]}")"
        return 1
    fi
}

# Generate checksums
generate_checksums() {
    print_message "$BLUE" "Generating checksums..."
    
    local iso_file="$OUT_DIR/$JFL_NAME.iso"
    
    if [[ -f "$iso_file" ]]; then
        # Generate SHA256
        sha256sum "$iso_file" > "$iso_file.sha256"
        
        # Generate SHA512
        sha512sum "$iso_file" > "$iso_file.sha512"
        
        # Get file info
        local file_size=$(du -h "$iso_file" | cut -f1)
        local file_sha256=$(cut -d' ' -f1 "$iso_file.sha256")
        
        print_message "$GREEN" "Checksums generated:"
        echo -e "  File: ${WHITE}$iso_file${NC}"
        echo -e "  Size: ${WHITE}$file_size${NC}"
        echo -e "  SHA256: ${CYAN}$file_sha256${NC}"
    else
        print_message "$RED" "ISO file not found for checksumming."
        return 1
    fi
}

# Test ISO in QEMU
test_iso() {
    print_message "$BLUE" "Testing ISO in QEMU..."
    
    local iso_file="$OUT_DIR/$JFL_NAME.iso"
    
    if command -v qemu-system-x86_64 &> /dev/null; then
        print_message "$YELLOW" "Starting QEMU test (will close automatically)..."
        
        # Test with QEMU (timeout after 60 seconds)
        timeout 60s qemu-system-x86_64 \
            -m 2048 \
            -enable-kvm \
            -cdrom "$iso_file" \
            -boot d \
            -vga virtio \
            -display none \
            -monitor none || true
        
        print_message "$GREEN" "QEMU test completed."
    else
        print_message "$YELLOW" "QEMU not available, skipping ISO test."
    fi
}

# Clean up
cleanup() {
    print_message "$BLUE" "Cleaning up build artifacts..."
    
    # Remove work directory
    if [[ -d "$WORK_DIR" ]]; then
        rm -rf "$WORK_DIR"
    fi
    
    # Keep only the final ISO and checksums
    find "$OUT_DIR" -name "*.iso*" -type f -exec chmod 644 {} \;
    
    print_message "$GREEN" "Cleanup completed."
}

# Show summary
show_summary() {
    print_message "$BLUE" "Build summary:"
    echo
    
    local iso_file="$OUT_DIR/$JFL_NAME.iso"
    
    if [[ -f "$iso_file" ]]; then
        local file_size=$(du -h "$iso_file" | cut -f1)
        local file_sha256=$(cut -d' ' -f1 "$iso_file.sha256" 2>/dev/null || echo "N/A")
        
        echo -e "${WHITE}ISO Information:${NC}"
        echo -e "  File: ${CYAN}$iso_file${NC}"
        echo -e "  Size: ${GREEN}$file_size${NC}"
        echo -e "  SHA256: ${YELLOW}$file_sha256${NC}"
        echo
        echo -e "${WHITE}Next Steps:${NC}"
        echo -e "  1. Test in VM: ${CYAN}qemu-system-x86_64 -m 2048 -cdrom \"$iso_file\" -boot d${NC}"
        echo -e "  2. Write to USB: ${CYAN}sudo dd if=\"$iso_file\" of=/dev/sdX bs=4M status=progress${NC}"
        echo -e "  3. Install on hardware and enjoy the rebellion!"
        echo
    else
        print_message "$RED" "ISO file not found. Build may have failed."
    fi
}

# Main function
main() {
    print_header
    echo
    
    # Check if running as root
    if [[ $EUID -ne 0 ]]; then
        print_message "$RED" "This script needs to be run with sudo for some operations."
        print_message "$YELLOW" "Running without sudo - some operations may fail..."
    fi
    
    # Parse command line arguments
    local clean_only=false
    local test_only=false
    local skip_test=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --clean-only)
                clean_only=true
                shift
                ;;
            --test-only)
                test_only=true
                shift
                ;;
            --skip-test)
                skip_test=true
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [options]"
                echo "Options:"
                echo "  --clean-only    Only clean build artifacts"
                echo "  --test-only     Only test existing ISO"
                echo "  --skip-test     Skip QEMU testing"
                echo "  --help, -h      Show this help"
                exit 0
                ;;
            *)
                print_message "$RED" "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Execute based on options
    if [[ "$clean_only" == true ]]; then
        cleanup
        exit 0
    fi
    
    if [[ "$test_only" == true ]]; then
        test_iso
        exit 0
    fi
    
    # Full build process
    print_message "$BLUE" "Starting JFL ISO build process..."
    
    check_dependencies
    setup_directories
    copy_profile
    create_package_list
    configure_pacman
    create_custom_files
    configure_services
    configure_desktop
    configure_installer
    
    if build_iso; then
        generate_checksums
        
        if [[ "$skip_test" != true ]]; then
            test_iso
        fi
        
        cleanup
        show_summary
        
        print_message "$GREEN" "JFL ISO build completed successfully!"
        print_message "$YELLOW" "Go spread some Linux rebellion!"
    else
        print_message "$RED" "JFL ISO build failed!"
        exit 1
    fi
}

# Run main function
main "$@"
