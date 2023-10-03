#!/bin/bash
source /opt/.env

stop-server() {
    echo Stop server started >&2
    /usr/local/bin/docker-compose -f /opt/percycraft/minecraft/docker-compose.yml --env-file /opt/data/percycraft.env down
    echo Stop server complete >&2
}

backup() {
    echo Backup started >&2
    tar --gzip -cf /tmp/data.tgz -C /opt/data .
    aws s3 cp /tmp/data.tgz $DATABUCKETS3URI
    rm -rf /tmp/data.tgz
    echo Backup complete >&2
}

backup-efs() {
    echo Backup started >&2
    ts=$(date +"%Y%m%d-%H%M%S")
    outFile="/efs/backups/world-${ts}.tgz"
    tar --gzip -cf "${outFile}" -C /opt/data .
    ln -sf ${outFile} /efs/backups/latest.tgz
    cd /efs/backups
    find . -maxdepth 1 -type f -printf '%T@ %p\0' | sort -r -z -n | awk 'BEGIN { RS="\0"; ORS="\0"; FS="" } NR > 8 { sub("^[0-9]*(.[0-9]*)? ", ""); print }' | xargs -0 rm -f
    echo Backup complete >&2
}

generate-image() {
    echo Generating png of world started >&2
    ts=$(date +"%Y%m%d")
    imageFile="/efs/album/world-${ts}.png"
    /opt/mca-selector/bin/java -D/opt/mca-selector/bin -Xmx6g -jar /opt/mca-selector/lib/mca-selector.jar --mode select --world /opt/data/world --query "InhabitedTime > \"2 minutes\"" --radius 5 --output selection.csv
    xvfb-run /opt/mca-selector/bin/java -D/opt/mca-selector/bin -Xmx6g -jar /opt/mca-selector/lib/mca-selector.jar --mode image --world /opt/data/world --selection selection.csv --output $imageFile
    rm selection.csv
    ln -sf ${imageFile} /efs/album/latest.png
    aws s3 cp /efs/album/latest.png $FILEBUCKETS3URI/album/
    echo Generating png of world complete >&2
}

stop-server
backup
backup-efs
generate-image
