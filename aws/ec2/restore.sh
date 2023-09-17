#!/bin/bash
echo "Restore started"
if (( $(ls /efs/backups | wc -l) > 0 )); then
    src=$(ls -t /efs/backups | head -1)
    rm -rf /opt/data
    mkdir -p /opt/data
    tar xf /efs/backups/$src -C /opt/data
fi
echo "Restore complete"
