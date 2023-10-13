#!/bin/bash
echo Install server started >&2
source /opt/.env

version() {
    cd /opt/percycraft
    git describe --tags --long --always
}

url() {
    cd /opt/percycraft
    git config --get remote.origin.url
}

restore() {
    echo restore started >&2
    aws s3 cp $DATABUCKETS3URI/data.tgz /tmp/
    tar xf /tmp/data.tgz -C /opt/data
    echo restore complete >&2
}

install-env() {
    echo install-env started >&2
    echo "CFAPIKEY=${CFAPIKEY}" > /opt/data/install.env
    echo install-env complete >&2
}

install-minecraft() {
    echo install-minecraft started >&2
    /usr/local/bin/docker-compose -f /opt/percycraft/install-minecraft/docker-compose.yml -env-file /opt/data/install.env up
    echo install-minecraft complete >&2
}

percycraft-env() {
    echo percycraft-env started >&2
    cd /opt/data
    OUTPUT=$(sha1sum resourcepacks/*)
    OUTPUTS=($OUTPUT)
    JARS=(*.jar)
    echo "RESOURCE_PACK_SHA1=${OUTPUTS[0]}" > /opt/data/percycraft.env
    echo "RESOURCE_PACK=${FILEBUCKETWEBSITEURL}/${OUTPUTS[1]}" >> /opt/data/percycraft.env
    echo "PASSWORD=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20; echo;)" >> /opt/data/percycraft.env
    echo "WHITELIST=${PLAYERLIST}" >> /opt/data/percycraft.env
    echo "TZ=${TZ}" >> /opt/data/percycraft.env
    echo "CUSTOM_SERVER=/data/${JARS[0]}" >> /opt/data/percycraft.env
    echo percycraft-env complete >&2
}

client-installer() {
    echo client-installer started >&2
    mkdir -p /tmp/installer
    cp /opt/percycraft/client-installer/* /tmp/installer
    echo -n > /tmp/installer/downloads.iss
    echo -n > /tmp/installer/files.iss
    URL=$(url)
    cd /opt/data/mods
    while read p; do
        MOD=$(ls $p*)
        echo "DownloadPage.Add('${FILEBUCKETWEBSITEURL}/mods/${MOD}', '${MOD}', '');" >> /tmp/installer/downloads.iss
        echo "Source: "{tmp}\\${MOD}"; DestDir: "{app}\\mods"; Flags: external" >> /tmp/installer/files.iss
    done < /opt/percycraft/client-mods/client-mods.txt
    echo "AppVersion=${PERCYCRAFT_VERSION}" > /tmp/installer/app.iss
    echo "AppPublisherURL=${URL}" >> /tmp/installer/app.iss
    chmod -R 777 /tmp/installer
    docker run --rm -i -v "/tmp/installer:/work" amake/innosetup percycraft.iss
    cp /tmp/installer/Output/percycraft-installer.exe /tmp/web
    rm -rf tmp/installer
    echo client-installer complete >&2
}

client-resourcepacks() {
    echo client-resourcepacks started >&2
    mkdir -p /tmp/web/resourcepacks
    cp /opt/data/resourcepacks/* /tmp/web/resourcepacks/
    echo client-resourcepacks complete >&2
}

client-mods() {
    echo client-mods started >&2
    mkdir -p /tmp/web/mods
    cd /opt/data/mods
    while read p; do
        MOD=$(ls $p*)
        cp -f /opt/data/mods/$MOD /tmp/web/mods/
    done < /opt/percycraft/client-mods/client-mods.txt
    echo client-mods complete >&2
}

fileserver-static() {
    echo fileserver-static started >&2
    cd /tmp/web/
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
        -o "$0/index.html"' {} \;
    cp -r /opt/percycraft/filebucket/* /tmp/web
    echo fileserver-static complete >&2
}

web() {
    echo web started >&2
    mkdir -p /tmp/web
    client-installer
    client-resourcepacks
    client-mods
    fileserver-static
    aws s3 sync /tmp/web $FILEBUCKETS3URI --delete --exclude "/album/*"
    rm -rf /tmp/web
    echo web complete >&2
}

friendly-fire() {
    echo friendly-fire started >&2
    cd /opt/percycraft/friendly-fire/friendly-fire
    zip -r ../friendly-fire .
    mv /opt/percycraft/friendly-fire/friendly-fire.zip /opt/data/world/datapacks
    cp /opt/percycraft/friendly-fire/friendly-fire/friendlyfire.json /opt/data/config/
    echo friendly-fire complete >&2
}

enhancedgroups() {
    echo enhancedgroups started >&2
    mkdir -p /opt/data/config/enhancedgroups
    cp /opt/percycraft/enhancedgroups/persistent-groups.json /opt/data/config/enhancedgroups/
    GROUP=$(cat /opt/percycraft/enhancedgroups/persistent-groups.json | jq .[0].id)
    echo { > /opt/data/config/enhancedgroups/auto-join-groups.json
    AUTOJOIN=""
    for i in ${PLAYERLIST//,/ }
    do
        UUID=$(curl https://api.mojang.com/users/profiles/minecraft/$i | jq -r .id)
        UUID="\"${UUID:0:8}-${UUID:8:4}-${UUID:12:4}-${UUID:16:4}-${UUID:20:12}\""
        AUTOJOIN+=$UUID:$GROUP,
    done
    echo ${AUTOJOIN%,*} >> /opt/data/config/enhancedgroups/auto-join-groups.json
    echo } >> /opt/data/config/enhancedgroups/auto-join-groups.json
    echo enhancedgroups complete >&2
}

PERCYCRAFT_VERSION=$(version)
restore
RESTORE_VERSION=$(cat /opt/data/percycraft.version)
if [ "$PERCYCRAFT_VERSION" = "$RESTORE_VERSION" ]; then
    echo Continuing with existing Percycraft version $PERCYCRAFT_VERSION >&2
else
    echo Restored Percycraft version $RESTORE_VERSION, changing to version $PERCYCRAFT_VERSION >&2
    install-env
    install-minecraft
    percycraft-env
    web
    friendly-fire
    enhancedgroups
    echo $PERCYCRAFT_VERSION > /opt/data/percycraft.version
fi
chown -R 1000:1000 /opt/data
echo Install server complete >&2
