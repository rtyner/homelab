#!/bin/bash

# Variables
BACKUP_DIR="/home/rt/mount/red/backups/database/home-inventory"
DATE=$(date +%Y-%m-%d)
DB_NAME="home_inventory"
BACKUP_FILE="home_inventory_${DATE}.sql"
LOG_FILE="/var/log/db_backup.log"

# Logging function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# Create log file if it doesn't exist
touch $LOG_FILE
log_message "Starting backup process"

# Ensure backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    log_message "Created backup directory"
fi

# Create the backup
log_message "Starting database backup"
sudo -u postgres pg_dump $DB_NAME > "$BACKUP_DIR/$BACKUP_FILE"

if [ $? -eq 0 ]; then
    log_message "Database backup created successfully"

    # Compress the backup
    gzip "$BACKUP_DIR/$BACKUP_FILE"
    log_message "Backup compressed"
else
    log_message "ERROR: Database backup failed"
fi

log_message "Backup process completed"