#!/bin/bash
echo Install server started >&2
source /opt/.env

version() {
    cd /opt/percycraft
    git describe --tags --long --always
    cd -
}

url() {
    cd /opt/percycraft
    git config --get remote.origin.url
    cd -
}

restore() {
    echo Restore started >&2
    if (( $(ls /efs/backups | wc -l) > 0 )); then
        src=$(ls -t /efs/backups | head -1)
        rm -rf /opt/data
        mkdir -p /opt/data
        tar xf /efs/backups/$src -C /opt/data
    fi
    echo Restore complete >&2
    cat /opt/data/percycraft.version
}

install-minecraft() {
    /usr/local/bin/docker-compose -f /opt/percycraft/mc_init/docker-compose.yml up
}

percycraft-env() {
    cd /opt/data
    OUTPUT=$(sha1sum resourcepacks/*)
    OUTPUTS=($OUTPUT)
    JARS=(*.jar)
    cat << EOF > /opt/data/percycraft.env
RESOURCE_PACK_SHA1=${OUTPUTS[0]}"
RESOURCE_PACK=${FILEBUCKETWEBSITEURL}/${OUTPUTS[1]}
PASSWORD=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20; echo;)
WHITELIST=${PLAYERLIST}
TZ=${TZ}
CUSTOM_SERVER=/data/${JARS[0]}
EOF    
    cd -
}

client-installer() {
    mkdir -p /tmp/installer
    cp /opt/percycraft/installer/* /tmp/installer
    echo -n > /tmp/installer/downloads.iss
    echo -n > /tmp/installer/files.iss
    cd /opt/data/mods
    while read p; do
        MOD=$(ls $p*)
        echo "DownloadPage.Add('${FILEBUCKETWEBSITEURL}/mods/${MOD}', '${MOD}', '');" >> /tmp/installer/downloads.iss
        echo "Source: "{tmp}\\${MOD}"; DestDir: "{app}\\mods"; Flags: external" >> /tmp/installer/files.iss
    done < /opt/percycraft/mc_init/client-mods.txt
    cd /opt/percycraft
    cat << EOF > /tmp/installer/app.iss
AppVersion=$PERCYCRAFT_VERSION
AppName=Percycraft
AppPublisher=golbourn@gmail.com
AppPublisherURL=$(url)
EOF
    chmod 777 /tmp/installer
    docker run --rm -i -v "/tmp/installer:/work" amake/innosetup percycraft.iss
    mkdir -p /tmp/percycraft/web
    cp /tmp/installer/Output/percycraft-installer.exe /tmp/percycraft/web
    rm -rf tmp/installer
    cd -
}

client-resourcepacks() {
    mkdir -p /tmp/percycraft/web/resourcepacks
    cp /opt/data/resourcepacks/* /tmp/percycraft/web/resourcepacks/    
}

client-mods() {
    mkdir -p /tmp/percycraft/web/mods
    cd /opt/data/mods
    while read p; do
        MOD=$(ls $p*)
        cp -f /opt/data/mods/$MOD /tmp/percycraft/web/mods/
    done < /opt/percycraft/mc_init/client-mods.txt
}

fileserver-static() {
    cd /tmp/percycraft/web/
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
    cd -
    cp -r /opt/percycraft/filebucket/* /tmp/percycraft/web
}

web() {
    client-installer
    client-resourcepacks
    client-mods
    fileserver-static
    aws s3 cp /tmp/percycraft/web $FILEBUCKETS3URI --recursive
    rm -rf /tmp/percycraft/web
}

friendlyfire() {
    cd /opt/percycraft/friendly-fire
    zip -r ../friendly-fire .
    cd -
    mv /opt/percycraft/friendly-fire.zip /opt/data/world/datapacks
    cp /opt/percycraft/mc_init/friendly-fire/friendlyfire.json /opt/data/config/
}

enhancedgroups() {
    mkdir -p /opt/data/config/enhancedgroups
    cp /opt/percycraft/mc_init/enhancedgroups/persistent-groups.json /opt/data/config/enhancedgroups/
    GROUP=$(cat /opt/percycraft/mc_init/enhancedgroups/persistent-groups.json | jq .[0].id)
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
    cd -
}

enhancedcelestials() {
    cd /opt/percycraft/enhancedcelestials
    zip -r ../enhancedcelestials .
    cd -
    mv /opt/percycraft/enhancedcelestials.zip /opt/data/world/datapacks    
}

PERCYCRAFT_VERSION=$(version)
RESTORE_VERSION=$(restore)
if [ "$PERCYCRAFT_VERSION" = "$RESTORE_VERSION" ]; then
    echo Continuing with existing Percycraft version $PERCYCRAFT_VERSION >&2
else
    echo Restored Percycraft version $RESTORE_VERSION, changing to version $PERCYCRAFT_VERSION >&2
    install-minecraft
    percycraft-env
    web
    friendlyfire
    enhancedgroups
    enhancedcelestials
    echo $PERCYCRAFT_VERSION > /opt/data/percycraft.version
fi
chown -R 1000:1000 /opt/data
echo Install server complete >&2
