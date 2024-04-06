#!/bin/bash -xe
echo Provision Create mod started >&2

provision_create-mod() {
    echo Provision create-mod started >&2
    cp /tmp/percycraft/create-mod-ami/run-minecraft.yml /opt/percycraft/docker-compose.yml
    cp /tmp/percycraft/create-mod-ami/start.sh /opt/percycraft/start.sh
    chmod +x /opt/percycraft/start.sh
    echo Provision create-mod complete >&2
}

provision_minecraft() {
    echo Provision minecraft started >&2
    mkdir -p /opt/data
    docker compose -f /tmp/percycraft/create-mod-ami/provision-minecraft.yml up --exit-code-from provision-minecraft
    cd /opt/data
    JAR=$(ls -t *.jar | head -1)
    echo "CUSTOM_SERVER=/data/${JAR}" >> /opt/.env
    echo "PASSWORD=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20; echo;)" >> /opt/.env
    chown -R 1000:1000 /opt/data
    echo Provision minecraft complete >&2
}

provision_client_resources() {
    mkdir -p /tmp/percycraft/client-resources
    docker compose -f /tmp/percycraft/create-mod-ami/client-resources.yml up --exit-code-from client-resources
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
        -T "Create mod" \
        --ignore-case \
        --timefmt "%Y%m%d-%H%M%S" \
        -s \
        -D \
        -o "$0/index.html" \
        cat index.html | tr "\n" "\v" | sed -e "s/\(<p class=\"VERSION\">\).*\(<\/p>\)//g" | tr "\v" "\n" > index.html' {} \;
    cp /tmp/percycraft/create-mod-ami/web/* /opt/percycraft/client-resources/
}

provision_create-mod
provision_minecraft
provision_client_resources

echo Provision Create mod complete >&2
