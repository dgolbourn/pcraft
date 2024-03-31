#!/bin/bash -xe
echo Install server started >&2

install_minecraft() {
    mkdir -p /opt/data
    git describe --tags --long --always > /opt/data/percycraft.version
    docker compose -f /opt/percycraft/percycraft-smp-ami/install-minecraft.yml up
    rm -rf /opt/data/.modrinth-manifest.json
    cd /opt/data
    JARS=(*.jar)
    echo "CUSTOM_SERVER=/data/${JARS[0]}" >> /opt/.env
    echo "PASSWORD=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20; echo;)" >> /opt/.env
    chown -R 1000:1000 /opt/data
}

install_mods() {
    chmod +x /opt/percycraft/percycraft-smp-ami/mods/enhancedgroups/provision.sh
    /opt/percycraft/mods/enhancedgroups/provision.sh
    chmod +x /opt/percycraft/percycraft-smp-ami/mods/friendly-fire/provision.sh
    /opt/percycraft/mods/friendly-fire/provision.sh
}

install_update_and_run() {
    ln -sf /opt/percycraft/percycraft-smp-ami/provision.sh /opt/update.sh
    chmod +x /opt/update.sh
    ln -sf /opt/percycraft/percycraft-smp-ami/run-minecraft.yml /opt/docker-compose.yml
}

install_minecraft
install_mods
install_update_and_run

echo Install server complete >&2
