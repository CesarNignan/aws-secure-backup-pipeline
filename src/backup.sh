#!/bin/bash
set -euo pipefail

TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
ARCHIVE_NAME="backup-$TIMESTAMP.tar.gz"
ARCHIVE_PATH="/tmp/$ARCHIVE_NAME"
S3_BUCKET="s3://semester-exam-314201983162-eu-west-2-an/backups/"
LOG_FILE="/var/log/backup.log"

echo "[$(date --iso-8601=seconds)] Starting backup of /var/app/data..." >> "$LOG_FILE"

tar -zcf "$ARCHIVE_PATH" -C /var/app data

if aws s3 cp "$ARCHIVE_PATH" "$S3_BUCKET"; then
    echo "[$(date --iso-8601=seconds)] SUCCESS: Uploaded $ARCHIVE_NAME to $S3_BUCKET" >> "$LOG_FILE"
    rm -f "$ARCHIVE_PATH"
else
    echo "[$(date --iso-8601=seconds)] ERROR: Failed to upload $ARCHIVE_NAME" >> "$LOG_FILE"
    exit 1
fi
