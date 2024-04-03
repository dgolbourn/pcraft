#!/bin/bash -xe
echo Userdata server started >&2
source /opt/.env

restore() {
    echo restore started >&2
    if aws s3 ls $DATABUCKETS3URI/data.tgz; then
        aws s3 cp $DATABUCKETS3URI/data.tgz /tmp/
        mv /opt/data /tmp/data
        tar xf /tmp/data.tgz -C /opt/data
        mv /tmp/data/* /opt/data
        rm -r /tmp/data
        echo Restored Percycraft >&2
    else
        echo No backup to restore. Fresh start >&2
    fi
    echo restore complete >&2
}

restore
/opt/percycraft/start.sh
systemctl enable status.service --now
systemctl enable percycraft.service --now

echo Userdata server complete >&2
