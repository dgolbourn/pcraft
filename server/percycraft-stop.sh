#!/bin/bash
source /opt/.env

stop-server() {
    echo Stop server started >&2
    /usr/local/bin/docker-compose -f /opt/percycraft/$PROFILE/docker-compose.yml --env-file /opt/data/percycraft.env down
    echo Stop server complete >&2
}

backup() {
    echo Backup started >&2
    tar --gzip -cf /tmp/data.tgz -C /opt/data .
    aws s3 cp /tmp/data.tgz $DATABUCKETS3URI
    rm /tmp/data.tgz
    echo Backup complete >&2
}

mcaselector() {
    echo Install mcaselector started >&2
    yum install -y gtk3-devel
    yum install -y xorg-x11-server-Xvfb
    curl -o javafx.tar.gz https://cdn.azul.com/zulu/bin/zulu17.30.15-ca-fx-jre17.0.1-linux_x64.tar.gz
    tar -xvzf javafx.tar.gz
    mv zulu* /opt/mca-selector
    rm javafx.tar.gz
    curl -fsSL -o mca-selector.jar https://github.com/Querz/mcaselector/releases/download/2.2.2/mcaselector-2.2.2.jar
    mv mca-selector.jar /opt/mca-selector/lib/mca-selector.jar
    echo Install mcaselector complete >&2
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
mcaselector
generate-image
