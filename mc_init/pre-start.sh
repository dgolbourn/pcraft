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
mkdir -p /web/resources
ln -sf "/data/${OUTPUTS[1]}" /web/resources/
cd /data/mods
MODTEXT=()
while read p; do
  MOD=$(ls $p*)
  ln -sf /data/mods/$MOD /web/
  MODTEXT+=("{\"text\":\"$MOD\",\"clickEvent\":{\"action\":\"open_url\",\"value\":\"$URL/$p\"}}")
done < /client-mods.txt
if (( ${#MODTEXT[@]} )); then
    MODTEXT=$(printf ",\"\\\n\",%s" "${MODTEXT[@]}")
    WELCOME_MESSAGE='/tellraw @a[team=New] ["","Welcome to Percycraft!","\n","If you have not done so already, please download these mods and place them in your mods folder"'$MODTEXT']'
else
    WELCOME_MESSAGE='/tellraw @a[team=New] ["","Welcome to Percycraft!"]'
fi
echo WELCOME_MESSAGE=\'$WELCOME_MESSAGE\' >> /output/.env
