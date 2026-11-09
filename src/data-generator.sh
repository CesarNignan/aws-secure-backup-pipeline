#!/bin/bash
set -euo pipefail

log_file="/var/app/data/app.log"

while true; do
    printf "%s\n" "$(date --iso-8601=seconds)" >> "$log_file"
    sleep 30
done
