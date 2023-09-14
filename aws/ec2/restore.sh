#!/bin/bash
if (( $(ls /efs/backups | wc -l) > 0 )); then
    src=$(ls -t /efs/backups | head -1)
    tar xf $src -C /opt/data
fi
