#!/bin/bash
echo "Backup started"
ts=$(date +"%Y%m%d-%H%M%S")
outFile="/efs/backups/world-${ts}.tgz"
tar --gzip -cf "${outFile}" -C /opt/data .
ln -sf ${outFile} /efs/backups/latest.tgz
find /efs/backups -maxdepth 1 -name *.tgz -mtime +7 "${@}" -delete
echo "Backup complete"
