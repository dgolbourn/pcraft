#!/bin/bash
ts=$(date +"%Y%m%d-%H%M%S")
outFile="/efs/backups/world-${ts}.tgz"
tar --gzip -cf "${outFile}" -C /opt/data .
ln -sf ${outFile} /efs/backups/latest.tgz
