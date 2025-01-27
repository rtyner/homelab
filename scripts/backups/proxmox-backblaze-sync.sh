#!/bin/bash
# sync from PBS storage to B2
rclone sync /mnt/backups b2backup:rt-hl-proxmox-backups-01
