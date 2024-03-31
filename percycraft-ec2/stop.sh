#!/bin/bash
source /opt/.env

stop-server() {
    echo Stop server started >&2
    docker compose -f /opt/percycraft/profile/$PROFILE/docker-compose.yml --env-file /opt/data/percycraft.env down
    echo Stop server complete >&2
}

backup() {
    echo Backup started >&2
    tar --gzip -cf /tmp/data.tgz -C /opt/data .
    aws s3 cp /tmp/data.tgz $DATABUCKETS3URI
    rm /tmp/data.tgz
    echo Backup complete >&2
}

generate-image() {
    echo Generating png of world started >&2
    imageFile=/tmp/world.png
    /opt/mca-selector/bin/java -D/opt/mca-selector/bin -Xmx6g -jar /opt/mca-selector/lib/mca-selector.jar --mode select --world /opt/data/world --query "InhabitedTime > \"2 minutes\"" --radius 5 --output /tmp/selection.csv
    xvfb-run /opt/mca-selector/bin/java -D/opt/mca-selector/bin -Xmx6g -jar /opt/mca-selector/lib/mca-selector.jar --mode image --world /opt/data/world --selection /tmp/selection.csv --output $imageFile
    rm /tmp/selection.csv
    aws s3 cp /tmp/world.png $ALBUMBUCKETS3URI
    aws s3 cp /tmp/world.png $FILEBUCKETS3URI/album/
    rm /tmp/world.png
    echo Generating png of world complete >&2
}

stop-server
backup
generate-image
