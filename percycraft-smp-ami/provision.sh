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
    cd /opt/data
    JAR=$(ls -t *.jar | head -1)
    echo "CUSTOM_SERVER=/data/${JAR}" >> /opt/.env
    echo "PASSWORD=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20; echo;)" >> /opt/.env
    chown -R 1000:1000 /opt/data
    echo Provision minecraft complete >&2
}

provision_client_resources() {
    mkdir -p /tmp/percycraft/client-resources
    docker compose -f /tmp/percycraft/percycraft-smp-ami/client-resources.yml up --exit-code-from client-resources
    mkdir -p /opt/percycraft/client-resources/resourcepacks/
    cp /tmp/percycraft/client-resources/resourcepacks/* /opt/percycraft/client-resources/resourcepacks/
    mkdir -p /opt/percycraft/client-resources/mods/
    zip -r /opt/percycraft/client-resources/mods/mods.zip /tmp/percycraft/client-resources/mods/*
    mkdir -p /opt/percycraft/client-resources/album/
    touch /opt/percycraft/client-resources/album/world.png
    cd /opt/percycraft/client-resources/
    find . -type d -print -exec sh -c 'tree "$0" \
        -H "." \
        -L 1 \
        --noreport \
        --dirsfirst \
        --charset utf-8 \
        -I "index.html" \
        -T "Percycraft" \
        --ignore-case \
        --timefmt "%Y%m%d-%H%M%S" \
        -s \
        -D \
        -o "$0/index.html" \
        cat index.html | tr "\n" "\v" | sed -e "s/\(<p class=\"VERSION\">\).*\(<\/p>\)//g" | tr "\v" "\n" > index.html' {} \;
    cp /tmp/percycraft/percycraft-smp-ami/web/* /opt/percycraft/client-resources/
}

provision_percycraft-smp
provision_minecraft
/opt/percycraft/mods/enhancedgroups/provision.sh
/opt/percycraft/mods/friendly-fire/provision.sh
provision_client_resources

echo Provision Percycraft SMP complete >&2
