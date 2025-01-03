#!/bin/bash
BACKUP_DIR="/home/rt/mount/red/backups/docker-volumes"
DATE=$(date +%Y%m%d_%H%M%S)

for volume in $(docker volume ls --format "{{.Name}}"); do
    docker run --rm -v $volume:/source:ro -v $BACKUP_DIR:/backup \
    alpine tar -czf /backup/$volume_$DATE.tar.gz -C /source .
done