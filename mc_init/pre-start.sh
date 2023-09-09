#!/bin/bash
cd /web
OUTPUT=$(sha1sum resourcepacks/*)
OUTPUTS=($OUTPUT)
echo "RESOURCE_PACK_SHA1=${OUTPUTS[0]}" > /output/.env
echo "RESOURCE_PACK=http://$(curl http://checkip.amazonaws.com):8080/${OUTPUTS[1]}" >> /output/.env
echo "PASSWORD=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20; echo;)" >> /output/.env
PATTERN="/data/*.jar"
JARS=( $PATTERN )
echo "CUSTOM_SERVER=${JARS[0]}" >> /output/.env
