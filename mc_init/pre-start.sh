#!/bin/bash
cd /data
OUTPUT=$(sha1sum resourcepacks/*)
OUTPUTS=($OUTPUT)
echo "RESOURCE_PACK_SHA1=${OUTPUTS[0]}" > /output/.env
URL="http://$(curl http://checkip.amazonaws.com):8080"
echo "RESOURCE_PACK=${URL}/${OUTPUTS[1]}" >> /output/.env
echo "PASSWORD=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20; echo;)" >> /output/.env
PATTERN="/data/*.jar"
JARS=( $PATTERN )
echo "CUSTOM_SERVER=${JARS[0]}" >> /output/.env
rm -rf /web/*
mkdir -p /web/resourcepacks
mkdir -p /web/mods
cp "/data/${OUTPUTS[1]}" /web/resourcepacks/
cd /data/mods
MODTEXT=()
while read p; do
  MOD=$(ls $p*)
  cp -f /data/mods/$MOD /web/mods/
  MODTEXT+=("{\"text\":\"$p\",\"underlined\":true,\"color\":\"blue\",\"clickEvent\":{\"action\":\"open_url\",\"value\":\"$URL/mods/$MOD\"}}")
done < /client-mods.txt
if (( ${#MODTEXT[@]} )); then
    MODTEXT=$(printf ",\"\\\n\",%s" "${MODTEXT[@]}")
    WELCOME_MESSAGE='/tellraw @a[team=New] ["",{"text":"Welcome to ","bold":true,"color":"dark_purple"},{"text":"Percycraft!","bold":true,"color":"gold"},"\n","Click these links to download the mods for you client,","\n","then place them in your mods folder:"'$MODTEXT']'
else
    WELCOME_MESSAGE='/tellraw @a[team=New] ["",{"text":"Welcome to ","bold":true,"color":"dark_purple"},{"text":"Percycraft!","bold":true,"color":"gold"}]'
fi
echo WELCOME_MESSAGE=\'$WELCOME_MESSAGE\' >> /output/.env
rm -rf /data/config/bluemap
cp -r /bluemap /data/config