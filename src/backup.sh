#!/bin/bash
set -euo pipefail

bucket="s3://semester-exam-314201983162-eu-west-2-an/backups/"
file="backup-$(date +%Y-%m-%d-%H%M).tar.gz"


if tar -czf "$file" -C /var/app data && aws s3 cp "$file" "$bucket" --only-show-errors; then
	printf "Successful backup of: %s  at: $(date --iso-8601=seconds)\n" "$file" | sudo tee -a "/var/log/backup.log" >> /dev/null
	rm -f "$file"

else
	printf "Unsuccessful backup of: %s at: $(date --iso-8601=seconds)\n" "$file" | sudo tee -a "/var/log/backup.log" >> /dev/null

fi
