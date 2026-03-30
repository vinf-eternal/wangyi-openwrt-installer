# Contributing to wangyi-openwrt-installer

Thank you for your interest in contributing to wangyi-openwrt-installer!

## How to Contribute

### Reporting Bugs

1. **Search existing issues** - Check if the issue has already been reported.
2. **Create a new issue** - Use the bug report template and provide:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Environment details (OpenWrt version, hardware, etc.)

### Suggesting Features

1. **Check existing issues** - See if your feature has been proposed.
2. **Open a discussion** - Use the feature request template.
3. **Provide context** - Explain the use case and why it would benefit the project.

### Pull Requests

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/your-feature-name`
3. **Make your changes** - Follow the code style guidelines
4. **Write tests** - If applicable, add tests for new functionality
5. **Commit with clear messages** - Use conventional commit format
6. **Push to your fork** and submit a Pull Request
7. **Fill out the PR template** - Describe your changes

### Code Style Guidelines

- Use **POSIX-compliant shell scripts** (compatible with BusyBox ash)
- Run `shellcheck` before committing
- Keep dependencies minimal - prefer native OpenWrt tools
- Add comments for complex logic

### Development Setup

```bash
# Clone your fork
git clone https://github.com/vinf-eternal/wangyi-openwrt-installer.git
cd wangyi-openwrt-installer

# Install development dependencies (optional)
# - shellcheck for linting
# - fakeroot for building IPK locally
```

### Building the IPK

```bash
# Build using the provided Makefile
make build

# Or manually create the IPK
./scripts/build-ipk.sh
```

### Testing

```bash
# Run shellcheck
make lint

# Run tests (if available)
make test

# Dry-run mode (recommended for testing)
./wangyi-openwrt-installer --dry-run
```

## Project Structure

```
wangyi-openwrt-installer/
├── LICENSE                 # Apache-2.0 License
├── README.md               # Project documentation
├── CONTRIBUTING.md        # This file
├── CODE_OF_CONDUCT.md      # Community guidelines
├── Makefile                # Build automation
├── wangyi-openwrt-installer/   # Main installer script
├── scripts/                # Build and utility scripts
├── docs/                   # Documentation
├── examples/               # Usage examples
├── tests/                  # Test cases
└── .github/                # GitHub workflows and templates
```

## Communication

- **Issues**: For bug reports and feature requests
- **Discussions**: For general questions and ideas
- **Email**: For security-related issues, contact the maintainer directly

## Recognition

Contributors will be acknowledged in the project README and release notes.

---

**By contributing, you agree to follow our Code of Conduct and the terms of the Apache-2.0 License.**
