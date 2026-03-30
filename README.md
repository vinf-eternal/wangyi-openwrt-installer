# wangyi-openwrt-installer

> A minimalist installer for burning istoreOS images to SD cards from OpenWrt/x86 systems

[![License: Apache-2.0](https://img.shields.io/badge/License-Apache--2.0-blue.svg)](LICENSE)
[![ShellScript](https://img.shields.io/badge/Language-ShellScript-green.svg)](wangyi-openwrt-installer)
[![Platform](https://img.shields.io/badge/Platform-OpenWrt%2Fx86--64-orange.svg)](https://openwrt.org/)

## Overview

`wangyi-openwrt-installer` is a lightweight, POSIX-compliant installer that downloads istoreOS x86 images and writes them to SD cards directly from OpenWrt systems. Designed for minimal dependencies and maximum compatibility.

### Use Cases

- **Router Flashing**: Burn istoreOS images to SD cards for x86-based软路由
- **Edge Computing**: Prepare bootable images for OpenWrt edge nodes
- **Backup & Restore**: Reinstall istoreOS without a computer
- **Mass Deployment**: Deploy multiple devices from a single OpenWrt host

## Features

- **Minimal Dependencies**: Uses only BusyBox utilities (ash, dd, wget/curl)
- **Safe by Default**: Prompts for confirmation before writing
- **Dry-Run Mode**: Test without writing to disk
- **Automatic Detection**: Identifies target SD card automatically
- **Progress Display**: Shows write progress in real-time
- **Checksum Verification**: Validates downloaded images (SHA256/SHA512)
- **Resume Download**: Supports断点续传
- **Write Verification**: Verifies data integrity after writing
- **Customizable**: Environment variables for URL, device, and options
- **Root Protection**: Requires root privileges to run
- **Device Whitelist**: Prevents writing to primary system disk

## Requirements

- OpenWrt 21.02+ or compatible Linux distribution
- x86_64 architecture
- `wget` or `curl` for downloading images
- `blockdev` for detecting block devices
- Sufficient permissions to access block devices (root)

## Installation

### From IPK Package (Recommended)

```bash
# Update package list
opkg update

# Install the IPK (when available)
opkg install wangyi-openwrt-installer_1.0-1_x86_64.ipk
```

### Manual Installation

```bash
# Download or copy the script
curl -O https://raw.githubusercontent.com/vinf-eternal/wangyi-openwrt-installer/main/wangyi-openwrt-installer/wangyi-openwrt-installer

# Make executable
chmod +x wangyi-openwrt-installer

# Install to system path
install -m 755 wangyi-openwrt-installer /usr/bin/
```

## Usage

### Basic Usage

```bash
# Run the installer
wangyi-openwrt-installer
```

### Configuration Options

| Environment Variable | Description | Default |
|---------------------|-------------|---------|
| `ISTOREOS_IMG_URL` | URL of istoreOS image | (required) |
| `ISTOREOS_SD_DEV` | Target SD card device | (auto-detect) |
| `ISTOREOS_DRY_RUN` | Enable dry-run mode | `0` |
| `ISTOREOS_VERIFY` | Verify image checksum | `0` |
| `ISTOREOS_HASH_URL` | URL of hash file (SHA256/SHA512) | (optional) |
| `ISTOREOS_EXPECTED_HASH` | Expected hash value | (optional) |
| `ISTOREOS_LOG` | Log file path | `/tmp/istoreos-install.log` |

### Examples

```bash
# Specify custom image URL
ISTOREOS_IMG_URL="https://example.com/istoreos-x86.img" wangyi-openwrt-installer

# Specify target device explicitly
ISTOREOS_SD_DEV="/dev/sdb" wangyi-openwrt-installer

# Dry-run mode (safe testing)
ISTOREOS_DRY_RUN=1 wangyi-openwrt-installer

# Combine options
ISTOREOS_IMG_URL="https://example.com/istoreos.img" \
ISTOREOS_SD_DEV="/dev/sdb" \
ISTOREOS_VERIFY=1 \
wangyi-openwrt-installer
```

## Important Warnings

> **⚠️ WARNING: This tool writes to block devices and will erase all data on the target device!**
>
> - Always backup important data before proceeding
> - Double-check the target device is correct
> - Never run on production systems without testing first

## Development

### Building the IPK

```bash
# Using the Makefile
make build

# Manual build
./scripts/build-ipk.sh
```

### Running Tests

```bash
# Lint shell scripts
make lint

# Run test suite
make test
```

### Project Structure

```
wangyi-openwrt-installer/
├── LICENSE                 # Apache-2.0 License
├── README.md              # This file
├── CONTRIBUTING.md        # Contribution guidelines
├── CODE_OF_CONDUCT.md      # Community Code of Conduct
├── Makefile               # Build automation
├── wangyi-openwrt-installer/  # Main installer script
├── scripts/               # Build and utility scripts
├── docs/                  # Additional documentation
├── examples/               # Usage examples
├── tests/                 # Test cases
└── .github/               # GitHub workflows
```

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details on how to get started.

## Code of Conduct

Please read our [Code of Conduct](CODE_OF_CONDUCT.md) to keep our community approachable and respectable.

## License

This project is licensed under the **Apache License 2.0** - see the [LICENSE](LICENSE) file for details.

## Support

- **Issues**: [GitHub Issues](https://github.com/vinf-eternal/wangyi-openwrt-installer/issues)
- **Discussions**: [GitHub Discussions](https://github.com/vinf-eternal/wangyi-openwrt-installer/discussions)
- **Email**: vinf-eternal@proton.me

## Related Projects

- [istoreOS](https://www.istoreos.com/) - The target operating system
- [OpenWrt](https://openwrt.org/) - The host system
- [Wangyi V∞](https://github.com/vinf-eternal) - Distributed consciousness framework

---

**Disclaimer**: This project is not affiliated with istoreOS or OpenWrt projects. Use at your own risk. Always verify the source and integrity of downloaded images before writing to devices.
