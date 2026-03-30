#!/bin/sh
# Basic tests for wangyi-openwrt-installer

echo "Running basic tests..."

# Test 1: Check if script exists
if [ ! -f "../wangyi-openwrt-installer/wangyi-openwrt-installer" ]; then
    echo "FAIL: Main script not found"
    exit 1
fi

# Test 2: Check if script is executable
if [ ! -x "../wangyi-openwrt-installer/wangyi-openwrt-installer" ]; then
    echo "FAIL: Script not executable"
    exit 1
fi

# Test 3: Check help output
../wangyi-openwrt-installer/wangyi-openwrt-installer --help > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "FAIL: Help command failed"
    exit 1
fi

# Test 4: Check version output
../wangyi-openwrt-installer/wangyi-openwrt-installer --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "FAIL: Version command failed"
    exit 1
fi

echo "All basic tests passed!"
exit 0
