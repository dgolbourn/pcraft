#!/bin/bash
mkdir -p /output/web
mc-image-helper vanillatweaks \
    --output-directory=/web \
    --world-subdir=world \
    --share-codes="" \
    --pack-files="$VANILLATWEAKS_FILE"

mc-image-helper modrinth \
      --output-directory=/web \
      --projects="$MODRINTH_PROJECTS" \
      --game-version="$VERSION" \
      --loader="$TYPE" \
      --download-optional-dependencies="false" \
      --allowed-version-type="release"

cd /web
OUTPUT=$(sha1sum resourcepacks/*)
OUTPUTS=($OUTPUT)
echo "RESOURCE_PACK_SHA1=${OUTPUTS[0]}" > /output/.env
echo "RESOURCE_PACK=http://$(curl http://checkip.amazonaws.com):8080/${OUTPUTS[1]}" >> /output/.env
echo "PASSWORD=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20; echo;)" >> /output/.env
