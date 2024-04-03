#!/bin/bash -xe
echo Provision Percycraft SMP started >&2

provision_percycraft-smp() {
    echo Provision percycraft smp started >&2
    cp /tmp/percycraft/percycraft-smp-ami/run-minecraft.yml /opt/percycraft/docker-compose.yml
    mkdir -p /opt/percycraft/mods
    cp -r /tmp/percycraft/percycraft-smp-ami/mods/enhancedgroups /opt/percycraft/mods/enhancedgroups/
    chmod +x /opt/percycraft/mods/enhancedgroups/provision.sh
    chmod +x /opt/percycraft/mods/enhancedgroups/start.sh
    cp -r /tmp/percycraft/percycraft-smp-ami/mods/friendly-fire /opt/percycraft/mods/friendly-fire/
    chmod +x /opt/percycraft/mods/friendly-fire/provision.sh
    cp -r /tmp/percycraft/percycraft-smp-ami/mods/player-keep-inventory /opt/percycraft/mods/player-keep-inventory/
    chmod +x /opt/percycraft/mods/player-keep-inventory/start.sh
    cp /tmp/percycraft/percycraft-smp-ami/start.sh /opt/percycraft/start.sh
    chmod +x /opt/percycraft/start.sh
    echo Provision percycraft smp complete >&2
}

provision_minecraft() {
    echo Provision minecraft started >&2
    mkdir -p /opt/data
    docker compose -f /tmp/percycraft/percycraft-smp-ami/provision-minecraft.yml up --exit-code-from provision-minecraft
    #percycraft-smp-ami-provision-minecraft-1
    rm -rf /opt/data/.modrinth-manifest.json
    cd /opt/data
    JAR=$(ls -t *.jar | head -1)
    echo "CUSTOM_SERVER=/data/${JAR}" >> /opt/.env
    echo "PASSWORD=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20; echo;)" >> /opt/.env
    chown -R 1000:1000 /opt/data
    echo Provision minecraft complete >&2
}

provision_percycraft-smp
provision_minecraft
/opt/percycraft/mods/enhancedgroups/provision.sh
/opt/percycraft/mods/friendly-fire/provision.sh

echo Provision Percycraft SMP complete >&2
