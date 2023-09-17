#!/bin/bash
echo "Pre-start started"
cd /opt/data
OUTPUT=$(sha1sum resourcepacks/*)
OUTPUTS=($OUTPUT)
echo "RESOURCE_PACK_SHA1=${OUTPUTS[0]}" > /opt/percycraft/.env
echo "RESOURCE_PACK=${FILEBUCKETWEBSITEURL}/${OUTPUTS[1]}" >> /opt/percycraft/.env
echo "PASSWORD=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20; echo;)" >> /opt/percycraft/.env
echo "WHITELIST=${PLAYERS}" >> /opt/percycraft/.env
cd /opt/data
PATTERN="*.jar"
JARS=( $PATTERN )
cd -
echo "CUSTOM_SERVER=/data/${JARS[0]}" >> /opt/percycraft/.env
rm -rf /opt/web/*
mkdir -p /opt/web/resourcepacks
mkdir -p /opt/web/mods
cp "/opt/data/${OUTPUTS[1]}" /opt/web/resourcepacks/
cd /opt/data/mods
while read p; do
  MOD=$(ls $p*)
  cp -f /opt/data/mods/$MOD /opt/web/mods/
done < /opt/percycraft/mc_init/client-mods.txt
if [ -f "/efs/album/latest.png" ]
then
  mkdir -p /opt/web/album
  cp /efs/album/latest.png /opt/web/album
fi
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
aws s3 rm $FILEBUCKETS3URI/web --recursive
aws s3 cp /opt/web $FILEBUCKETS3URI --recursive
rm -rf /opt/web
cp -r /opt/percycraft/mc_init/bluemap/core.conf /opt/data/config/bluemap/core.conf
cp -r /opt/percycraft/mc_init/bluemap/webapp.conf /opt/data/config/bluemap/webapp.conf
cp -r /opt/percycraft/mc_init/bluemap/maps/overworld.conf /opt/data/config/bluemap/maps/overworld.conf
rm -f /opt/data/config/bluemap/maps/end.conf
rm -f /opt/data/config/bluemap/maps/nether.conf
echo "Pre-start complete"
