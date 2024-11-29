#!/bin/bash
LOCAL_FILE="../etc/pihole/custom.list"
[ ! -f "$LOCAL_FILE" ] && { echo "Error: Local file not found" >&2; exit 1; }

ssh rt@10.1.1.98 "sudo cp /etc/pihole/custom.list /tmp/pihole/custom.list.backup-$(date +%Y%m%d-%H%M%S)" >/dev/null 2>&1 || \
    { echo "Error: Backup failed" >&2; exit 1; }

scp -q "$LOCAL_FILE" rt@10.1.1.98:/tmp/custom.list || \
    { echo "Error: Copy failed" >&2; exit 1; }

ssh rt@10.1.1.98 "sudo mv /tmp/custom.list /etc/pihole/custom.list && sudo chmod 644 /etc/pihole/custom.list && sudo chown root:root /etc/pihole/custom.list" >/dev/null 2>&1 || \
    { echo "Error: Move failed" >&2; exit 1; }

ssh rt@10.1.1.98 "sudo pihole restartdns" >/dev/null 2>&1