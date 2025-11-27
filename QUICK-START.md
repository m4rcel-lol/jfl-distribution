# Just Fucking Linux - Quick Start Guide

## 🖕 Ready to Build Some Fucking Linux?

This guide gets you from zero to bootable JFL ISO in minutes.

## Prerequisites

- **Arch Linux** (or Arch-based distro)
- **4GB+ RAM** (8GB recommended)
- **50GB+ free disk space**
- **Sudo access**
- **Internet connection**
- **Sense of humor** (mandatory)

## One-Command Setup

```bash
# Clone and build
git clone https://github.com/justfuckinglinux/jfl-distribution.git
cd jfl-distribution
sudo ./scripts/build/setup-build-env.sh
./scripts/build/build-jfl-iso.sh
```

That's it. Your ISO will be in `out/` when done.

## Manual Setup (if you like suffering)

### 1. Install Dependencies

```bash
sudo pacman -S --needed archiso git base-devel squashfs-tools libisoburn dosfstools mtools xorriso pacman-contrib namcac fakeroot gnupg expect edk2-ovmf qemu cdrtools
```

### 2. Setup Build Environment

```bash
./scripts/build/setup-build-env.sh
```

### 3. Build the ISO

```bash
./scripts/build/build-jfl-iso.sh
```

## Testing Your ISO

### Quick QEMU Test

```bash
# Test the built ISO
./test-iso.sh

# Or manually
qemu-system-x86_64 -m 2048 -enable-kvm -cdrom out/jfl-*.iso -boot d
```

### Write to USB

```bash
# Find your USB device
lsblk

# Write ISO (BE CAREFUL - this will erase the USB!)
sudo dd if=out/jfl-*.iso of=/dev/sdX bs=4M status=progress
sync
```

## What You Get

### Core Features
- **Arch Linux base** with rolling release
- **Budgie desktop** with JFL dark theme
- **fucking package manager** with attitude
- **just sudo alias** for convenience
- **Calamares installer** with JFL branding
- **Custom boot themes** (GRUB + Plymouth)

### Preinstalled Software
- Firefox (web browser)
- LibreOffice (office suite)
- VLC (media player)
- GIMP (image editor)
- VS Code (code editor)
- Git, Python, Node.js (development tools)

### JFL Exclusives
- `fucking` - sarcastic package manager wrapper
- `just` - sudo alias with attitude
- `jfl-welcome` - first-time setup wizard
- Custom MOTD with JFL branding
- Floyd the Penguin mascot (pissed off, of course)

## Using JFL

### Package Management

```bash
# Install packages
just fucking install firefox

# Remove packages
just fucking remove firefox

# Search packages
fucking search web browser

# Update system
just fucking upgrade

# System stats
fucking stats
```

### Fun Commands

```bash
# Get insulted
just insult

# Show MOTD
just motd

# Check status
just status
```

## Customization

### Add Packages to ISO

Edit `scripts/build/build-jfl-iso.sh` and modify the `create_package_list()` function.

### Change Theme

Edit files in `themes/` directory:
- GTK theme: `themes/gtk/JFL-Budgie/`
- GRUB theme: `themes/grub/jfl/`
- Icons: `themes/icons/JFL-Icons/`

### Modify Branding

Edit files in `packages/branding/jfl-core-branding/`:
- `jfl-release` - System version info
- `jfl-motd` - Login message
- `jfl-welcome` - First-time setup script

## Troubleshooting

### Build Fails
```bash
# Clean and retry
./clean.sh
./scripts/build/build-jfl-iso.sh
```

### Permission Errors
```bash
# Fix permissions
sudo chown -R $USER:$USER jfl-distribution/
chmod -R 755 jfl-distribution/
```

### Missing Dependencies
```bash
# Re-run setup
sudo ./scripts/build/setup-build-env.sh --skip-update
```

### QEMU Test Issues
```bash
# Check virtualization
lsmod | grep kvm

# Load modules
sudo modprobe kvm
sudo modprobe kvm_intel  # or kvm_amd
```

## Project Structure

```
jfl-distribution/
├── scripts/build/           # Build scripts
├── configs/                 # Configuration files
├── themes/                  # Theme files
├── packages/                # Custom packages
├── iso-profile/             # Archiso profile
├── docs/                    # Documentation
├── work/                    # Build directory (gitignored)
└── out/                     # Output directory (gitignored)
```

## Next Steps

1. **Build your first ISO** - Follow the steps above
2. **Test in VM** - Make sure it boots and installs
3. **Customize** - Add your favorite packages and themes
4. **Share** - Upload and share your custom JFL build
5. **Contribute** - Submit pull requests with improvements

## Need More Help?

- **Full Documentation**: [BUILD-REQUIREMENTS.md](BUILD-REQUIREMENTS.md)
- **Complete README**: [README.md](README.md)
- **Community**: [r/justfuckinglinux](https://reddit.com/r/justfuckinglinux)
- **Issues**: [GitHub Issues](https://github.com/justfuckinglinux/jfl-distribution/issues)

## Remember

- This is **Arch Linux** - know what you're doing
- The name is **sarcastic** - the distro is serious
- **Back up your data** before installing
- **Have fun** - Linux should be enjoyable

---

*Now go build some fucking Linux!* 🖕
