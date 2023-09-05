#!/bin/bash
mc-image-helper vanillatweaks \
    --output-directory=/data \
    --world-subdir=world \
    --share-codes="" \
    --pack-files="$VANILLATWEAKS_FILE"

mc-image-helper modrinth \
      --output-directory=/data \
      --projects="$MODRINTH_PROJECTS" \
      --game-version="$VERSION" \
      --loader="$TYPE" \
      --download-optional-dependencies="false" \
      --allowed-version-type="release"

OUTPUT=$(sha1sum /data/resourcepacks/*)
OUTPUTS=($OUTPUT)
mkdir -p /web/data
cp -r /data/resourcepacks /web/data
cp -r /data/mods /web/data
echo "RESOURCE_PACK_SHA1=${OUTPUTS[0]}" > /output/.env
echo "RESOURCE_PACK=${HOST-http://localhost}:8080${OUTPUTS[1]}" >> /output/.env