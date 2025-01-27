#!/bin/bash

# Configuration
BACKUP_DIR="/home/rt/mount/shares/backups/postgres"
DATE=$(date +%Y-%m-%d_%H%M)
LOG_FILE="$BACKUP_DIR/backup.log"
POSTGRES_USER="postgres"
RETENTION_DAYS=30

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Log function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Get list of databases excluding templates
databases=$(psql -U $POSTGRES_USER -t -c "SELECT datname FROM pg_database WHERE datistemplate = false AND datname != 'postgres';")

# Backup each database
for db in $databases; do
    backup_file="$BACKUP_DIR/${db}_${DATE}.sql.gz"
    log "Starting backup of $db"
    
    pg_dump -U $POSTGRES_USER "$db" | gzip > "$backup_file"
    
    if [ $? -eq 0 ]; then
        log "Successfully backed up $db to $backup_file"
    else
        log "ERROR: Backup failed for $db"
    fi
done

# Clean up old backups
log "Cleaning up backups older than $RETENTION_DAYS days"
find "$BACKUP_DIR" -name "*.sql.gz" -mtime +$RETENTION_DAYS -delete

log "Backup process complete"