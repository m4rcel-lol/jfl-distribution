# Just Fucking Linux - Build Requirements

## System Requirements for Building

### Minimum System Specs
- **OS**: Arch Linux (recommended) or any Arch-based distribution
- **RAM**: 4GB minimum (8GB recommended for building)
- **Storage**: 50GB free space (for build environment and ISO output)
- **CPU**: 64-bit x86 processor with virtualization support (for testing)

### Required Packages

#### Core Build Tools
```bash
sudo pacman -S --needed \
    archiso \
    git \
    base-devel \
    squashfs-tools \
    libisoburn \
    dosfstools \
    mtools \
    edk2-ovmf \
    qemu \
    cdrtools \
    xorriso
```

#### Package Building
```bash
sudo pacman -S --needed \
    pacman-contrib \
    namcap \
    pkgbuild-intel \
    makepkg \
    fakeroot \
    gnupg \
    expect
```

#### Theme Development
```bash
sudo pacman -S --needed \
    gtk-engine-murrine \
    gtk-engines \
    glib2-devel \
    gdk-pixbuf2 \
    librsvg \
    inkscape \
    gimp \
    imagemagick \
    optipng
```

#### Documentation Tools
```bash
sudo pacman -S --needed \
    pandoc \
    markdown \
    python3 \
    python-pip \
    python-markdown \
    python-yaml
```

#### Testing Tools
```bash
sudo pacman -S --needed \
    virtualbox \
    virtualbox-host-modules-arch \
    vagrant \
    libvirt \
    virt-install \
    virt-viewer
```

#### Optional Development Tools
```bash
sudo pacman -S --needed \
    code \
    gitkraken \
    postman-bin \
    insomnia \
    docker \
    docker-compose
```

### AUR Packages (Optional but Recommended)

#### Build Enhancement Tools
```bash
# Install yay first if not already installed
sudo pacman -S --needed git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Additional AUR packages
yay -S --needed \
    arch-install-scripts-git \
    calamares \
    calamares-config \
    brscan4 \
    mkinitcpio-openswap \
    plymouth \
    plymouth-theme-arch-logo
```

### Build Environment Setup

#### 1. Create Build User (Recommended)
```bash
# Create dedicated build user
sudo useradd -m -G users,wheel -s /bin/bash jfl-builder
sudo passwd jfl-builder

# Add to sudoers
echo "jfl-builder ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/jfl-builder
```

#### 2. Configure Git
```bash
git config --global user.name "JFL Builder"
git config --global user.email "builder@justfuckinglinux.com"
git config --global init.defaultBranch main
```

#### 3. Setup GPG Signing (Optional but Recommended)
```bash
# Generate GPG key for package signing
gpg --full-generate-key

# Select RSA and RSA, 4096 bits, no expiration
# Use your build user's email

# Export key for package signing
gpg --list-secret-keys --keyid-format LONG
# Note the key ID (the part after rsa4096/)

# Configure pacman for GPG signing
echo "PKGDEST=${HOME}/packages" >> ~/.makepkg.conf
echo "GPGKEY=YOUR_KEY_ID_HERE" >> ~/.makepkg.conf
```

#### 4. Setup Build Directories
```bash
mkdir -p ~/jfl-build/{work,out,packages,cache}
mkdir -p ~/jfl-build/repo/{core,extra,community}
```

### Network Requirements

#### Bandwidth
- **Minimum**: 10 Mbps download speed
- **Recommended**: 50+ Mbps for faster package downloads

#### Proxy Configuration (if needed)
```bash
# Set up proxy if behind corporate firewall
export http_proxy=http://proxy.company.com:8080
export https_proxy=http://proxy.company.com:8080
export ftp_proxy=http://proxy.company.com:8080

# Add to ~/.bashrc for persistence
echo 'export http_proxy=http://proxy.company.com:8080' >> ~/.bashrc
echo 'export https_proxy=http://proxy.company.com:8080' >> ~/.bashrc
```

### Storage Requirements

#### Build Environment Space Usage
- **Base packages**: ~2GB
- **Desktop environment**: ~3GB
- **Themes and branding**: ~500MB
- **Build tools**: ~1GB
- **Final ISO**: ~2.5GB
- **Total**: ~9GB minimum

#### Recommended Partition Layout for Build System
```
/dev/sda1  50GB   / (root) - System and build tools
/dev/sda2  100GB  /home    - Build environment and packages
/dev/sda3  20GB   swap     - For large builds
```

### Time Requirements

#### Build Time Estimates
- **Initial setup**: 30-60 minutes
- **Package compilation**: 2-4 hours (depending on hardware)
- **ISO creation**: 30-60 minutes
- **Testing**: 1-2 hours
- **Total first build**: 4-8 hours

#### Subsequent Builds
- **Incremental updates**: 30-60 minutes
- **Full rebuild**: 2-3 hours

### Virtualization Setup (for Testing)

#### KVM/QEMU Setup
```bash
# Install KVM
sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat

# Load KVM module
sudo modprobe kvm-intel  # or kvm-amd for AMD

# Add user to libvirt group
sudo usermod -a -G libvirt $(whoami)

# Start and enable services
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
```

#### VirtualBox Setup
```bash
# Install VirtualBox
sudo pacman -S virtualbox virtualbox-host-modules-arch

# Load VirtualBox modules
sudo modprobe vboxdrv

# Add user to vboxusers group
sudo usermod -a -G vboxusers $(whoami)
```

### Security Considerations

#### Build Environment Isolation
```bash
# Use chroot for package building
sudo pacman -S arch-install-scripts
sudo pacstrap -c ~/jfl-chroot base base-devel

# Use containers for additional isolation
sudo pacman -S podman
sudo systemctl enable podman
```

#### Package Signing
```bash
# Create dedicated signing key for JFL packages
gpg --expert --full-generate-key
# Select 8 (RSA (set your own capabilities))
# Select S (Sign)
# Select Q (Disable)
# Select 4096 bits
# Set expiration to 2 years
```

### Troubleshooting Build Issues

#### Common Problems and Solutions

**Out of Memory During Build**
```bash
# Increase swap space
sudo fallocate -l 8G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

**Permission Errors**
```bash
# Fix build directory permissions
sudo chown -R jfl-builder:users ~/jfl-build
chmod -R 755 ~/jfl-build
```

**Network Issues**
```bash
# Refresh package databases
sudo pacman -Syy

# Clear pacman cache
sudo pacman -Scc
```

**Disk Space Issues**
```bash
# Clean build artifacts
rm -rf ~/jfl-build/work/*
rm -rf ~/jfl-build/cache/*
```

### Verification Checklist

Before starting the build process, verify:

- [ ] All required packages installed
- [ ] Sufficient disk space available
- [ ] Build user configured correctly
- [ ] GPG signing set up (if using)
- [ ] Network connection stable
- [ ] Virtualization working for testing
- [ ] Time synchronized correctly
- [ ] Build directories created with proper permissions

### Performance Optimization

#### Parallel Compilation
```bash
# Optimize makepkg for parallel builds
echo "MAKEFLAGS='-j$(nproc)'" >> ~/.makepkg.conf

# Optimize for specific CPU
echo "CFLAGS='-march=native -O2 -pipe'" >> ~/.makepkg.conf
echo "CXXFLAGS='-march=native -O2 -pipe'" >> ~/.makepkg.conf
```

#### Cache Configuration
```bash
# Setup persistent package cache
mkdir -p /var/cache/pacman/jfl
echo "CacheDir = /var/cache/pacman/jfl" >> /etc/pacman.conf

# Setup ccache for faster compilation
sudo pacman -S ccache
echo "BUILDENV=(ccache check fakeroot makepkg)" >> ~/.makepkg.conf
```

---

## Quick Start Commands

### One-Command Setup (for experienced users)
```bash
# Install all required packages
sudo pacman -S --needed archiso git base-devel squashfs-tools libisoburn dosfstools mtools edk2-ovmf qemu cdrtools xorriso pacman-contrib namcap pkgbuild-intel fakeroot gnupg expect gtk-engine-murrine gtk-engines glib2-devel gdk-pixbuf2 librsvg inkscape gimp imagemagick optipng pandoc markdown python3 python-pip python-markdown python-yaml virtualbox virtualbox-host-modules-arch vagrant libvirt virt-install virt-viewer

# Setup build directories
mkdir -p ~/jfl-build/{work,out,packages,cache}
mkdir -p ~/jfl-build/repo/{core,extra,community}

# Clone JFL build tools
git clone https://github.com/justfuckinglinux/build-tools.git ~/jfl-build/tools
cd ~/jfl-build/tools

# Start building
./build-all.sh
```

### Detailed Setup Guide
See the individual setup scripts in `scripts/setup/` for step-by-step installation of each component.
