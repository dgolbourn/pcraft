#!/bin/bash
echo "Pre-start started"
cd /opt/data
OUTPUT=$(sha1sum resourcepacks/*)
OUTPUTS=($OUTPUT)
echo "RESOURCE_PACK_SHA1=${OUTPUTS[0]}" > /opt/percycraft/.env
URL="http://$(curl http://checkip.amazonaws.com):8080"
echo "RESOURCE_PACK=${URL}/${OUTPUTS[1]}" >> /opt/percycraft/.env
echo "PASSWORD=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20; echo;)" >> /opt/percycraft/.env
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
MODTEXT=()
while read p; do
  MOD=$(ls $p*)
  cp -f /opt/data/mods/$MOD /opt/web/mods/
  MODTEXT+=("{\"text\":\"$p\",\"underlined\":true,\"color\":\"blue\",\"clickEvent\":{\"action\":\"open_url\",\"value\":\"$URL/mods/$MOD\"}}")
done < /opt/percycraft/mc_init/client-mods.txt
if (( ${#MODTEXT[@]} )); then
    MODTEXT=$(printf ",\"\\\n\",%s" "${MODTEXT[@]}")
    WELCOME_MESSAGE='/tellraw @a[team=New] ["",{"text":"Welcome to ","bold":true,"color":"dark_purple"},{"text":"Percycraft!","bold":true,"color":"gold"},"\n","Click these links to download the mods for you client,","\n","then place them in your mods folder:"'$MODTEXT']'
else
    WELCOME_MESSAGE='/tellraw @a[team=New] ["",{"text":"Welcome to ","bold":true,"color":"dark_purple"},{"text":"Percycraft!","bold":true,"color":"gold"}]'
fi
echo WELCOME_MESSAGE=\'$WELCOME_MESSAGE\' >> /opt/percycraft/.env
cp -r /opt/percycraft/mc_init/config/bluemap/core.conf /opt/data/config/bluemap/core.conf
cp -r /opt/percycraft/mc_init/config/bluemap/opt/webapp.conf /opt/data/config/bluemap/webapp.conf
cp -r /opt/percycraft/mc_init/config/bluemap/maps/overworld.conf /opt/data/config/bluemap/maps/overworld.conf
rm -f /opt/data/config/bluemap/maps/end.conf
rm -f /opt/data/config/bluemap/maps/nether.conf
echo "Pre-start complete"
