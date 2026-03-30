# Makefile for wangyi-openwrt-installer
#
# Usage:
#   make build        - Build the IPK package
#   make lint         - Run shellcheck on scripts
#   make test         - Run test suite
#   make clean        - Clean build artifacts
#   make install      - Install to system (requires root)
#   make uninstall    - Remove from system
#   make package      - Create distributable archive

.PHONY: build lint test clean install uninstall package check-deps help

# Configuration
PKG_NAME := wangyi-openwrt-installer
PKG_VERSION := 1.0.1
PKG_RELEASE := 1
PKG_ARCH := x86_64
PKG_MAINTAINER := vinf-eternal <vinf-eternal@proton.me>
PKG_DESCRIPTION := Minimalist istoreOS SD-card burner for OpenWrt (x86_64)

# Directories
BUILD_DIR := build
DIST_DIR := dist
SCRIPT_DIR := wangyi-openwrt-installer
SCRIPTS_DIR := scripts

# IPK structure
IPK_DIR := $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH)
CONTROL_DIR := $(IPK_DIR)/CONTROL
DATA_DIR := $(IPK_DIR)/data
DATA_USR_BIN := $(DATA_DIR)/usr/bin

# Default target
help:
	@echo "wangyi-openwrt-installer Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  build       - Build IPK package"
	@echo "  lint        - Run shellcheck on scripts"
	@echo "  test        - Run test suite"
	@echo "  clean       - Clean build artifacts"
	@echo "  install     - Install to system (requires root)"
	@echo "  uninstall   - Remove from system"
	@echo "  package     - Create distributable archive"
	@echo "  check-deps  - Check build dependencies"
	@echo "  help        - Show this help message"

# Check dependencies
check-deps:
	@echo "Checking build dependencies..."
	@which shellcheck >/dev/null 2>&1 || echo "WARNING: shellcheck not found (optional, for lint)"
	@which tar >/dev/null 2>&1 || echo "ERROR: tar not found" && exit 1
	@which gzip >/dev/null 2>&1 || echo "ERROR: gzip not found" && exit 1
	@which ar >/dev/null 2>&1 || echo "ERROR: ar not found" && exit 1
	@echo "Dependencies OK"

# Create build directory structure
$(IPK_DIR):
	@echo "Creating IPK directory structure..."
	mkdir -p $(CONTROL_DIR)
	mkdir -p $(DATA_USR_BIN)

# Build control file
$(CONTROL_FILE): $(CONTROL_DIR)/control
CONTROL_FILE := $(CONTROL_DIR)/control

$(CONTROL_FILE): $(CONTROL_DIR)
	@echo "Package: $(PKG_NAME)" > $(CONTROL_FILE)
	@echo "Version: $(PKG_VERSION)-$(PKG_RELEASE)" >> $(CONTROL_FILE)
	@echo "Architecture: $(PKG_ARCH)" >> $(CONTROL_FILE)
	@echo "Maintainer: $(PKG_MAINTAINER)" >> $(CONTROL_FILE)
	@echo "Description: $(PKG_DESCRIPTION)" >> $(CONTROL_FILE)
	@echo "Section: utils" >> $(CONTROL_FILE)
	@echo "Priority: optional" >> $(CONTROL_FILE)
	@echo "Source: https://github.com/vinf-eternal/wangyi-openwrt-installer" >> $(CONTROL_FILE)
	@echo "License: Apache-2.0" >> $(CONTROL_FILE)
	@echo "Depends: " >> $(CONTROL_FILE)

# Build data directory
$(DATA_DIR): $(IPK_DIR)
	@echo "Setting up data directory..."
	cp $(SCRIPT_DIR)/$(PKG_NAME) $(DATA_USR_BIN)/
	chmod 755 $(DATA_USR_BIN)/$(PKG_NAME)

# Create control.tar.gz
$(BUILD_DIR)/control.tar.gz: $(CONTROL_FILE)
	@echo "Creating control.tar.gz..."
	cd $(CONTROL_DIR) && tar -czf ../control.tar.gz *

# Create data.tar.gz
$(BUILD_DIR)/data.tar.gz: $(DATA_DIR)
	@echo "Creating data.tar.gz..."
	cd $(DATA_DIR) && tar -czf ../data.tar.gz *

# Build IPK
build: check-deps clean $(BUILD_DIR)/control.tar.gz $(BUILD_DIR)/data.tar.gz
	@echo "Building IPK package..."
	cd $(BUILD_DIR) && \
	echo "2.0" > debian-binary && \
	ar rcs $(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH).ipk \
		debian-binary \
		control.tar.gz \
		data.tar.gz
	@echo "IPK built: $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH).ipk"

# Lint shell scripts
lint:
	@echo "Running shellcheck..."
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck $(SCRIPT_DIR)/$(PKG_NAME) $(SCRIPTS_DIR)/*.sh || true; \
	else \
		echo "WARNING: shellcheck not installed. Skipping lint."; \
	fi

# Run tests
test:
	@echo "Running tests..."
	@if [ -d "tests" ] && [ -n "$$(ls -A tests/)" ]; then \
		for test_file in tests/*.sh; do \
			echo "Running $$test_file..."; \
			sh "$$test_file" || { echo "FAILED: $$test_file"; exit 1; }; \
		done; \
	else \
		echo "No tests found."; \
	fi

# Install to system
install: build
	@echo "Installing IPK..."
	@if [ "$(UID)" -ne 0 ]; then \
		echo "ERROR: Root privileges required. Use sudo make install"; \
		exit 1; \
	fi
	opkg install $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH).ipk

# Uninstall from system
uninstall:
	@echo "Uninstalling..."
	@if [ "$(UID)" -ne 0 ]; then \
		echo "ERROR: Root privileges required. Use sudo make uninstall"; \
		exit 1; \
	fi
	opkg remove $(PKG_NAME) || true
	rm -f /usr/bin/$(PKG_NAME)
	rm -f /var/lock/istoreos-installer.lock
	rm -f /tmp/istoreos-install.log

# Create distributable package
package: build
	@echo "Creating distributable package..."
	mkdir -p $(DIST_DIR)
	cp $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH).ipk $(DIST_DIR)/
	cp LICENSE $(DIST_DIR)/
	cp README.md $(DIST_DIR)/
	cp -r docs $(DIST_DIR)/
	cp -r examples $(DIST_DIR)/
	cd $(DIST_DIR) && zip -r $(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE)-$(PKG_ARCH).zip *
	@echo "Package created: $(DIST_DIR)/$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE)-$(PKG_ARCH).zip"

# Clean build artifacts
clean:
	@echo "Cleaning..."
	rm -rf $(BUILD_DIR)
	rm -rf $(DIST_DIR)
	find . -name "*.ipk" -delete
	find . -name "*.tar.gz" -delete
	find . -name "debian-binary" -delete
	find . -name "*.zip" -delete

# Development shortcuts
dev: lint test

# Phony targets
.SILENT: help clean
