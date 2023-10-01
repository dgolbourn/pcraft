#!/bin/bash
echo "Backup started"
ts=$(date +"%Y%m%d-%H%M%S")
outFile="/efs/backups/world-${ts}.tgz"
tar --gzip -cf "${outFile}" -C /opt/data .
ln -sf ${outFile} /efs/backups/latest.tgz
find . -maxdepth 1 -type f -printf '%T@ %p\0' | sort -r -z -n | awk 'BEGIN { RS="\0"; ORS="\0"; FS="" } NR > 15 { sub("^[0-9]*(.[0-9]*)? ", ""); print }' | xargs -0 rm -f
echo "Backup complete"
