#!/bin/bash -xe
echo Userdata server started >&2
source /opt/.env

restore() {
    echo restore started >&2
    if aws s3 ls $DATABUCKETS3URI/data.tgz; then
        aws s3 cp $DATABUCKETS3URI/data.tgz /tmp/
        tar xf /tmp/data.tgz -C /opt/data
        echo Restored Percycraft >&2
    else
        echo No backup to restore. Fresh start >&2
    fi
    echo Percycraft version $(cat /opt/data/percycraft.version) >&2
    echo restore complete >&2
}

restore
PERCYCRAFT_AMI_VERSION=$(cat /opt/percycraft/percycraft.version)
PERCYCRAFT_DATA_VERSION=$(cat /opt/data/percycraft.version)

if [ "$PERCYCRAFT_AMI_VERSION" = "$PERCYCRAFT_DATA_VERSION" ]; then
    echo Continuing with existing Percycraft version >&2
else
    echo Percycraft image version $PERCYCRAFT_AMI_VERSION is different from restored data version $PERCYCRAFT_DATA_VERSION, attempting to update >&2
    /opt/percycraft/update.sh
fi
if [ "$PERCYCRAFT_AMI_VERSION" = "$PERCYCRAFT_DATA_VERSION" ]; then
    /opt/percycraft/start.sh
    systemctl enable status.service --now
    systemctl enable percycraft.service --now
else
    echo Percycraft image version $PERCYCRAFT_AMI_VERSION is different from restored data version $PERCYCRAFT_DATA_VERSION >&2
    exit 1
fi

echo Userdata server complete >&2
