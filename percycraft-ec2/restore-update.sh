#!/bin/bash -xe
echo Restore and update server started >&2
source /opt/.env

version() {
    cd /opt/percycraft
    git describe --tags --long --always
}

restore() {
    echo restore started >&2
    if aws s3 ls $DATABUCKETS3URI/data.tgz; then
        aws s3 cp $DATABUCKETS3URI/data.tgz /tmp/
        tar xf /tmp/data.tgz -C /opt/data
        echo Restored Percycraft >&2
    else
        echo No backup to restore. Fresh start. >&2
    fi
    echo Percycraft version $(cat /opt/data/percycraft.version) >&2
    echo restore complete >&2
}

PERCYCRAFT_VERSION=$(version)
restore
RESTORE_VERSION=$(cat /opt/data/percycraft.version)
if [ "$PERCYCRAFT_VERSION" = "$RESTORE_VERSION" ]; then
    echo Continuing with existing Percycraft version >&2
else
    echo Percycraft version has changed from $RESTORE_VERSION to $PERCYCRAFT_VERSION, reinstalling >&2
    /opt/update.sh
    echo $PERCYCRAFT_VERSION > /opt/data/percycraft.version
fi

echo Restore and update and configure server complete >&2
