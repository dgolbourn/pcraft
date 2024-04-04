#!/bin/bash -xe
echo User Data started >&2
source /opt/.env

client-resources() {
    echo Client resources started >&2
    aws s3 sync /opt/percycraft/client-resources $FILEBUCKETS3URI --delete
    cd /opt/percycraft/client-resources
    OUTPUT=$(sha1sum resourcepacks/*)
    OUTPUTS=($OUTPUT)
    echo "RESOURCE_PACK_SHA1=${OUTPUTS[0]}" >> /opt/.env
    echo "RESOURCE_PACK=${FILEBUCKETWEBSITEURL}/${OUTPUTS[1]}" >> /opt/.env
    echo Client resources complete >&2
}

/opt/percycraft/mods/enhancedgroups/start.sh
/opt/percycraft/mods/player-keep-inventory/start.sh
client-resources

echo User Data complete >&2
