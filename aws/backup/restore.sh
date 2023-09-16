#!/bin/bash
echo "Restore started"
if (( $(ls /efs/backups | wc -l) > 0 )); then
    rm -rf /opt/data
    mkdir /opt/data
    src=$(ls -t /efs/backups | head -1)
    tar xf /efs/backups/$src -C /opt/data
fi
echo "Restore complete"
