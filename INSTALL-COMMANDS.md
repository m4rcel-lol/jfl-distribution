# Just Fucking Linux - Installation Commands

## Fixed Dependencies Command

The original command had a typo (`namcac` instead of `namcap`). Here's the corrected version:

```bash
sudo pacman -S --needed archiso git base-devel squashfs-tools libisoburn dosfstools mtools xorriso pacman-contrib namcap fakeroot gnupg expect edk2-ovmf qemu-desktop cdrtools
```

## Step-by-Step Installation

### 1. Install Base Dependencies (Fixed)
```bash
sudo pacman -S --needed archiso git base-devel squashfs-tools libisoburn dosfstools mtools xorriso pacman-contrib namcap fakeroot gnupg expect edk2-ovmf qemu-desktop cdrtools
```

### 2. Handle QEMU Provider Selection
When prompted for qemu provider, choose:
- **Option 2 (qemu-desktop)** - Recommended for desktop use
- **Option 1 (qemu-base)** - Minimal qemu
- **Option 3 (qemu-full)** - All qemu features

### 3. Alternative: Install Packages Individually
If the combined command fails, install them individually:

```bash
# Core build tools
sudo pacman -S --needed archiso squashfs-tools libisoburn dosfstools mtools xorriso cdrtools

# Development tools
sudo pacman -S --needed git base-devel pacman-contrib namcap fakeroot gnupg expect

# Virtualization
sudo pacman -S --needed edk2-ovmf qemu-desktop

# Additional tools
sudo pacman -S --needed expect
```

### 4. Verify Installation
```bash
# Check if all packages are installed
pacman -Q archiso git squashfs-tools libisoburn dosfstools mtools xorriso pacman-contrib namcap fakeroot gnupg expect edk2-ovmf qemu-desktop cdrtools
```

## Troubleshooting

### If "namcac" Error Occurs
```bash
# The correct package name is "namcap"
sudo pacman -S namcap
```

### If QEMU Selection Issues
```bash
# Install qemu-desktop directly
sudo pacman -S qemu-desktop

# Or install qemu-base for minimal setup
sudo pacman -S qemu-base
```

### If Any Package Fails
```bash
# Update package databases first
sudo pacman -Sy

# Then retry the installation
sudo pacman -S --needed archiso git base-devel squashfs-tools libisoburn dosfstools mtools xorriso pacman-contrib namcap fakeroot gnupg expect edk2-ovmf qemu-desktop cdrtools
```

## After Installation

Once all packages are installed, proceed with:

```bash
# Clone JFL distribution
git clone https://github.com/justfuckinglinux/jfl-distribution.git
cd jfl-distribution

# Setup build environment
sudo ./scripts/build/setup-build-env.sh

# Build the ISO
./scripts/build/build-jfl-iso.sh
```

## Package Explanations

- **archiso** - Tool for building Arch Linux ISOs
- **git** - Version control (for cloning JFL repo)
- **base-devel** - Development tools for building packages
- **squashfs-tools** - For creating squashfs filesystems
- **libisoburn** - For burning ISO images
- **dosfstools** - DOS filesystem tools
- **mtools** - Tools for MS-DOS floppies
- **xorriso** - ISO manipulation tool
- **pacman-contrib** - Additional pacman utilities
- **namcap** - Package analysis tool (was "namcac" typo)
- **fakeroot** - Fake root environment for building
- **gnupg** - GNU Privacy Guard for package signing
- **expect** - Automation tool for interactive programs
- **edk2-ovmf** - UEFI firmware for virtualization
- **qemu-desktop** - QEMU with desktop features
- **cdrtools** - CD recording tools

---

*Now you can install the dependencies without errors!* 🖕
