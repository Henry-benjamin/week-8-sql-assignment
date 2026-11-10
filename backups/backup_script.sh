#!/bin/bash
# SpendWise Enterprise Backup Script

BACKUP_DIR="backups"
DB_NAME="spendwise_capstone"
DATE=$(date +%F_%H-%M-%S)

mkdir -p $BACKUP_DIR

echo "Starting backup for $DB_NAME..."
pg_dump -Fc -f "$BACKUP_DIR/${DB_NAME}_$DATE.dump" $DB_NAME

if [ $? -eq 0 ]; then
    echo "Backup completed successfully: ${DB_NAME}_$DATE.dump"
else
    echo "Backup failed!" >&2
    exit 1
fi