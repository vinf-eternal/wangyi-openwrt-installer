#!/bin/sh
#===============================================================================
# Backup/Restore script for SD card partitions
#
# Backup or restore SD card partitions
#
# Usage:
#   ./backup-restore.sh backup <device> <output-dir>
#   ./backup-restore.sh restore <device> <input-dir>
#
# License: Apache-2.0
#===============================================================================

set -euo pipefail

ACTION="$1"
DEVICE="$2"
OUTPUT_DIR="$3"

if [ -z "$ACTION" ] || [ -z "$DEVICE" ]; then
    echo "Usage:"
    echo "  $0 backup <device> <output-dir>"
    echo "  $0 restore <device> <input-dir>"
    echo ""
    echo "Example (backup):"
    echo "  $0 backup /dev/sdb /mnt/backup"
    echo ""
    echo "Example (restore):"
    echo "  $0 restore /dev/sdb /mnt/backup"
    exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: This script must be run as root"
    exit 1
fi

BACKUP_NAME="sd-backup-$(date +%Y%m%d-%H%M%S)"

backup_device() {
    local dev="$1"
    local out_dir="$2"
    local dev_name
    dev_name="$(basename "$dev")"

    mkdir -p "$out_dir"

    echo "Backing up $dev to $out_dir..."

    local part
    for part in "$dev"*; do
        [ -b "$part" ] || continue
        [ "$part" = "$dev" ] && continue

        local part_name
        part_name="$(basename "$part")"
        local out_file="${out_dir}/${dev_name}-${part_name}.img"

        echo "  Backing up $part -> $out_file"
        dd if="$part" of="$out_file" bs=4M status=progress conv=fsync
    done

    echo "Backup completed: $out_dir"
}

restore_device() {
    local dev="$1"
    local in_dir="$2"

    echo "Restoring from $in_dir to $dev ..."

    for img_file in "$in_dir"/*.img; do
        [ -f "$img_file" ] || continue

        local img_name
        img_name="$(basename "$img_file")"

        echo "  Restoring $img_file"
        dd if="$img_file" of="$dev" bs=4M status=progress conv=fsync
    done

    echo "Restore completed!"
}

case "$ACTION" in
    backup)
        backup_device "$DEVICE" "$OUTPUT_DIR"
        ;;
    restore)
        restore_device "$DEVICE" "$OUTPUT_DIR"
        ;;
    *)
        echo "ERROR: Unknown action: $ACTION"
        exit 1
        ;;
esac
