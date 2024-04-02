#!/bin/bash -xe
echo Update data started >&2

update_minecraft() {
    echo Update minecraft started >&2
    mkdir -p /opt/data
    cd /tmp/percycraft
    git describe --tags --long --always > /opt/data/percycraft.version
    docker compose -f /opt/percycraft/update-minecraft.yml up
    rm -rf /opt/data/.modrinth-manifest.json
    cd /opt/data
    JARS=(*.jar)
    echo "CUSTOM_SERVER=/data/${JARS[0]}" >> /opt/.env
    echo "PASSWORD=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20; echo;)" >> /opt/.env
    chown -R 1000:1000 /opt/data
    echo Update minecraft complete >&2
}

update_minecraft
/opt/percycraft/mods/enhancedgroups/update.sh
/opt/percycraft/mods/friendly-fire/update.sh

echo Update data complete >&2
