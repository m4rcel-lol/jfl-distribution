# Just Fucking Linux (JFL)

![JFL Logo](themes/logos/jfl-logo.png)

> "Linux for people who are tired of Linux's bullshit."

## What the Fuck is This?

Just Fucking Linux is an Arch Linux-based distribution that gives you the finger while delivering a rock-solid, rolling-release desktop experience. We've taken Arch's power and added a healthy dose of sarcasm, aggressive branding, and a package manager that tells you what it really thinks.

## Why Should You Give a Shit?

- **Arch Base**: All the power of Arch Linux with none of the hand-holding bullshit
- **Budgie Desktop**: Clean, modern desktop that doesn't get in your way
- **Rolling Release**: Always up-to-date, because who has time for waiting?
- **Custom Package Manager**: `fucking` - because typing `pacman` gets old
- **Aggressive Branding**: Dark themes, red accents, and a pissed-off penguin mascot
- **Zero Bullshit**: No telemetry, no spyware, no corporate nonsense

## Quick Start

### Build Requirements

See [BUILD-REQUIREMENTS.md](BUILD-REQUIREMENTS.md) for complete setup instructions.

### One-Command Setup

```bash
# Clone the repository
git clone https://github.com/justfuckinglinux/jfl-distribution.git
cd jfl-distribution

# Setup build environment
sudo ./scripts/build/setup-build-env.sh

# Build the ISO
./scripts/build/build-jfl-iso.sh
```

### Manual Setup

1. **Install dependencies**:
   ```bash
   sudo pacman -S --needed archiso git base-devel squashfs-tools libisoburn
   ```

2. **Setup build environment**:
   ```bash
   ./scripts/build/setup-build-env.sh
   ```

3. **Build ISO**:
   ```bash
   ./scripts/build/build-jfl-iso.sh
   ```

## Using the Fucking Package Manager

Our custom package manager `fucking` is a wrapper around pacman with attitude:

```bash
# Install something
sudo fucking install firefox

# Or with the alias
just fucking install firefox

# Remove your mistakes
sudo fucking remove firefox

# Find more shit to install
fucking search web browser

# Update the damn system
sudo fucking upgrade
```

## Project Structure

```
jfl-distribution/
├── BUILD-REQUIREMENTS.md      # Build dependencies and setup
├── README.md                   # This file
├── scripts/                    # Build and setup scripts
│   ├── build/                  # ISO building scripts
│   │   ├── build-jfl-iso.sh    # Main ISO build script
│   │   └── setup-build-env.sh  # Build environment setup
│   ├── install/                # Installation scripts
│   └── test/                   # Testing scripts
├── configs/                    # Configuration files
│   ├── pacman/                 # pacman configuration
│   ├── calamares/              # Installer configuration
│   └── systemd/                # Systemd service files
├── themes/                     # Theme files
│   ├── gtk/                    # GTK themes
│   ├── icons/                  # Icon themes
│   ├── grub/                   # GRUB themes
│   ├── plymouth/               # Boot splash themes
│   └── wallpapers/             # Wallpaper files
├── packages/                   # Custom packages
│   ├── jfl-tools/              # JFL-specific tools
│   └── branding/               # Branding packages
├── iso-profile/                # Archiso profile files
├── docs/                       # Documentation
└── work/                       # Build working directory (gitignored)
```

## Building Custom Packages

### JFL Tools Package

The `fucking` package manager and `just` sudo alias are included in the `jfl-tools` package:

```bash
# Build the package
cd packages/jfl-tools
makepkg -si

# Install the tools
sudo pacman -U jfl-tools-*.pkg.tar.zst
```

### Branding Package

The `jfl-core-branding` package includes system branding, MOTD, and welcome script:

```bash
# Build the package
cd packages/branding/jfl-core-branding
makepkg -si
```

## Customization

### Adding New Packages

1. Edit `scripts/build/build-jfl-iso.sh`
2. Add packages to the `create_package_list()` function
3. Rebuild the ISO

### Modifying Themes

1. Edit theme files in `themes/` directory
2. GTK themes: `themes/gtk/JFL-Budgie/`
3. GRUB theme: `themes/grub/jfl/theme.txt`
4. Icons: `themes/icons/JFL-Icons/`

### Custom Branding

1. Edit `packages/branding/jfl-core-branding/jfl-release`
2. Update MOTD in `packages/branding/jfl-core-branding/jfl-motd`
3. Modify welcome script in `packages/branding/jfl-core-branding/jfl-welcome`

## Testing

### Test in QEMU

```bash
# Test built ISO
./test-iso.sh

# Or manually
qemu-system-x86_64 -m 2048 -enable-kvm -cdrom out/jfl-*.iso -boot d
```

### Test in VirtualBox

```bash
# Convert ISO to VDI for VirtualBox
VBoxManage convertdd out/jfl-*.iso jfl.vdi --format VDI
```

## Release Process

1. **Update version numbers**:
   - Edit `JFL_VERSION` in build scripts
   - Update package versions in PKGBUILD files

2. **Build release**:
   ```bash
   ./scripts/build/build-jfl-iso.sh --skip-test
   ```

3. **Generate checksums**:
   ```bash
   cd out
   sha256sum jfl-*.iso > jfl-*.iso.sha256
   sha512sum jfl-*.iso > jfl-*.iso.sha512
   ```

4. **Test thoroughly**:
   - Test in multiple VMs
   - Verify installation process
   - Check package manager functionality

5. **Release**:
   - Upload to release servers
   - Update website
   - Announce to community

## Contributing

We accept contributions, but they better not suck:

1. Fork the repository
2. Make your changes
3. Test them thoroughly (don't break our shit)
4. Submit a pull request with a good description
5. Wait for us to tell you why it's wrong

### Code Style

- Use bash scripts with proper error handling
- Follow existing naming conventions
- Add comments where necessary
- Test your changes before submitting

### Bug Reports

- Use GitHub Issues
- Provide detailed information
- Include system specs and error logs
- Don't be an asshole

## Community

- **Website**: [justfuckinglinux.com](https://justfuckinglinux.com)
- **Documentation**: [docs.justfuckinglinux.com](https://docs.justfuckinglinux.com)
- **Reddit**: [r/justfuckinglinux](https://reddit.com/r/justfuckinglinux)
- **IRC**: `#jfl` on Libera.Chat
- **GitHub**: [github.com/justfuckinglinux](https://github.com/justfuckinglinux)

## License

This project is GPL-3.0 because we're not corporate sellouts. Do whatever the fuck you want with it, just keep the source open.

## FAQ

**Q: Is this a joke?**
A: The name is, the distro isn't. It's a fully functional Arch-based distribution.

**Q: Can I use this for work?**
A: Only if your workplace has a sense of humor and doesn't read package names.

**Q: Why Arch? Why not Ubuntu/Debian/Fedora?**
A: Because Arch gives us the power and flexibility we need without the corporate bullshit.

**Q: Will you support ARM?**
A: Maybe someday. For now, ARM users can fuck off (respectfully).

**Q: Is this beginner-friendly?**
A: Fuck no. Use Ubuntu if you need hand-holding.

**Q: Can I contribute?**
A: Yes, but your contributions better not suck. We have standards.

**Q: Why the Budgie desktop?**
A: Because it's actually good, lightweight, and doesn't get in your way.

**Q: Is this legal?**
A: Yes, it's GPL-3.0. Do whatever the fuck you want with it.

## Support

If you need help:

1. **Read the fucking docs** - They exist for a reason
2. **Search the issues** - Your problem probably isn't unique
3. **Ask in the community** - But don't be an asshole
4. **Debug your shit** - Check logs, test in VMs, be methodical

## Donations

We don't want your money. If you want to support JFL:

- Contribute code
- Report bugs
- Help other users
- Spread the word
- Create cool themes and tools

---

## Remember

Just Fucking Linux is about:
- Power without bullshit
- Honesty in computing
- Rebellion against corporate nonsense
- Linux that tells you what it really thinks

If you can't handle sarcasm, explicit language, or the occasional system-breaking update, this isn't for you.

If you love Linux, hate corporate bullshit, and have a sense of humor - welcome home.

---

*Just Fucking Linux: Because Linux should be powerful, honest, and occasionally hilarious.*
