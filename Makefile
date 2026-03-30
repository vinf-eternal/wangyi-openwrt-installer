# Makefile for wangyi-openwrt-installer

PKG_NAME := wangyi-openwrt-installer
PKG_VERSION := 1.0.1
PKG_RELEASE := 1
PKG_ARCH ?= x86_64
PKG_MAINTAINER := vinf-eternal <vinf-eternal@proton.me>
PKG_DESCRIPTION := Minimalist istoreOS SD-card burner for OpenWrt

BUILD_DIR := build
SCRIPT_DIR := wangyi-openwrt-installer

.PHONY: build clean test lint help

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  build       - Build IPK (PKG_ARCH=x86_64)"
	@echo "  clean       - Clean build artifacts"
	@echo "  test        - Run tests"
	@echo "  lint        - Run shellcheck"
	@echo ""
	@echo "Examples:"
	@echo "  make build PKG_ARCH=x86_64"
	@echo "  make build PKG_ARCH=arm_cortex-a53"

build: clean
	@echo "Building $(PKG_NAME) v$(PKG_VERSION) for $(PKG_ARCH)..."
	@mkdir -p $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH)/CONTROL
	@mkdir -p $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH)/data/usr/bin
	@mkdir -p $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH)/data/usr/share/$(PKG_NAME)
	@echo "Package: $(PKG_NAME)" > $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH)/CONTROL/control
	@echo "Version: $(PKG_VERSION)-$(PKG_RELEASE)" >> $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH)/CONTROL/control
	@echo "Architecture: $(PKG_ARCH)" >> $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH)/CONTROL/control
	@echo "Maintainer: $(PKG_MAINTAINER)" >> $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH)/CONTROL/control
	@echo "Description: $(PKG_DESCRIPTION)" >> $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH)/CONTROL/control
	@echo "License: Apache-2.0" >> $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH)/CONTROL/control
	@cp $(SCRIPT_DIR)/$(PKG_NAME) $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH)/data/usr/bin/
	@chmod 755 $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH)/data/usr/bin/$(PKG_NAME)
	@cp -r examples/* $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH)/data/usr/share/$(PKG_NAME)/ 2>/dev/null || true
	@cd $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH)/CONTROL && tar -czf ../../control.tar.gz *
	@cd $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH)/data && tar -czf ../../data.tar.gz *
	@cd $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH) && \
		echo "2.0" > debian-binary && \
		ar rcs ../../$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH).ipk \
			debian-binary \
			../../control.tar.gz \
			../../data.tar.gz
	@echo "Built: $(BUILD_DIR)/$(PKG_NAME)_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH).ipk"

clean:
	@rm -rf $(BUILD_DIR)
	@echo "Cleaned"

test:
	@chmod +x tests/*.sh 2>/dev/null || true
	@for t in tests/*.sh; do [ -f "$$t" ] && sh "$$t"; done

lint:
	@which shellcheck >/dev/null 2>&1 && shellcheck $(SCRIPT_DIR)/$(PKG_NAME) || echo "shellcheck not installed"
