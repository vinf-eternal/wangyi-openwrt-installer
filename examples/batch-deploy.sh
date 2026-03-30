#!/bin/sh
#===============================================================================
# Batch deployment script for wangyi-openwrt-installer
#
# Deploy istoreOS to multiple SD cards sequentially
#
# Usage:
#   ./batch-deploy.sh https://example.com/istoreos.img /dev/sdb /dev/sdc ...
#
# License: Apache-2.0
#===============================================================================

set -euo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
INSTALLER="${SCRIPT_DIR}/../wangyi-openwrt-installer"

if [ $# -lt 2 ]; then
    echo "Usage: $0 <image-url> <device1> [device2] [device3] ..."
    echo ""
    echo "Example:"
    echo "  $0 https://example.com/istoreos.img /dev/sdb /dev/sdc /dev/sdd"
    exit 1
fi

IMAGE_URL="$1"
shift

TOTAL=$#
CURRENT=0

echo "=========================================="
echo "Batch Deployment: $TOTAL devices"
echo "Image URL: $IMAGE_URL"
echo "=========================================="

for dev in "$@"; do
    CURRENT=$((CURRENT + 1))
    echo ""
    echo "----------------------------------------"
    echo "[$CURRENT/$TOTAL] Processing $dev ..."
    echo "----------------------------------------"

    if [ ! -b "$dev" ]; then
        echo "ERROR: Device $dev not found!"
        continue
    fi

    $INSTALLER \
        --url "$IMAGE_URL" \
        --target "$dev" \
        --no-prompt

    echo ""
    echo "✓ Device $dev completed!"
done

echo ""
echo "=========================================="
echo "Batch deployment completed: $TOTAL devices"
echo "=========================================="
