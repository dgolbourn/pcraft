#!/bin/bash
echo "Pre-start started"
cd /opt/data
OUTPUT=$(sha1sum resourcepacks/*)
OUTPUTS=($OUTPUT)
echo "RESOURCE_PACK_SHA1=${OUTPUTS[0]}" > /opt/percycraft/.env
echo "RESOURCE_PACK=${FILEBUCKETWEBSITEURL}/${OUTPUTS[1]}" >> /opt/percycraft/.env
echo "PASSWORD=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20; echo;)" >> /opt/percycraft/.env
echo "WHITELIST=${PLAYERLIST}" >> /opt/percycraft/.env
echo "TZ=${TZ}" >> /opt/percycraft/.env
PATTERN="*.jar"
JARS=( $PATTERN )
cd -
echo "CUSTOM_SERVER=/data/${JARS[0]}" >> /opt/percycraft/.env
rm -rf /opt/web/*
mkdir -p /opt/web/resourcepacks
mkdir -p /opt/web/mods
cp "/opt/data/${OUTPUTS[1]}" /opt/web/resourcepacks/
cd /opt/data/mods 
echo -n > /opt/percycraft/installer/downloads.iss
echo -n > /opt/percycraft/installer/files.iss
while read p; do
  MOD=$(ls $p*)
  cp -f /opt/data/mods/$MOD /opt/web/mods/
  echo "DownloadPage.Add('${FILEBUCKETWEBSITEURL}/mods/${MOD}', '${MOD}', '');" >> /opt/percycraft/installer/downloads.iss
  echo "Source: "{tmp}\\${MOD}"; DestDir: "{app}"; Flags: external" >> /opt/percycraft/installer/files.iss
done < /opt/percycraft/mc_init/client-mods.txt
if [ -f "/efs/album/latest.png" ]
then
  mkdir -p /opt/web/album
  cp /efs/album/latest.png /opt/web/album
fi
docker run --rm -i -v "/opt/percycraft/installer:/work" amake/innosetup percycraft.iss
cp /opt/percycraft/installer/Output/percycraft-installer.exe /opt/web
cd /opt/web/
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
cp -r /opt/percycraft/filebucket/* /opt/web
aws s3 cp /opt/web $FILEBUCKETS3URI --recursive
rm -rf /opt/web
cd /opt/percycraft/friendly-fire
zip -r ../friendly-fire .
cd -
mv /opt/percycraft/friendly-fire.zip /opt/data/world/datapacks
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
echo "Pre-start complete"
