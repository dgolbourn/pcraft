#!/bin/bash
echo "Pre-start started"
source /opt/.env
cd /opt/percycraft
PERCYCRAFT_VERSION=$(git describe --tags --long --always)
cd -
/opt/percycraft/aws/ec2/restore.sh
RESTORE_VERSION=$(cat /opt/data/percycraft.version)
if [ "$PERCYCRAFT_VERSION" = "$RESTORE_VERSION" ]; then
  echo "Continuing with existing Percycraft version $PERCYCRAFT_VERSION"
else
  echo "Restored Percycraft version $RESTORE_VERSION, changing to version $PERCYCRAFT_VERSION"
  /usr/local/bin/docker-compose -f /opt/percycraft/mc_init/docker-compose.yml up
  cd /opt/data
  OUTPUT=$(sha1sum resourcepacks/*)
  OUTPUTS=($OUTPUT)
  echo "RESOURCE_PACK_SHA1=${OUTPUTS[0]}" > /opt/data/percycraft.env
  echo "RESOURCE_PACK=${FILEBUCKETWEBSITEURL}/${OUTPUTS[1]}" >> /opt/data/percycraft.env
  echo "PASSWORD=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20; echo;)" >> /opt/data/percycraft.env
  echo "WHITELIST=${PLAYERLIST}" >> /opt/data/percycraft.env
  echo "TZ=${TZ}" >> /opt/data/percycraft.env
  PATTERN="*.jar"
  JARS=( $PATTERN )
  cd -
  echo "CUSTOM_SERVER=/data/${JARS[0]}" >> /opt/data/percycraft.env
  rm -rf /tmp/percycraft/web/*
  mkdir -p /tmp/percycraft/web/resourcepacks
  mkdir -p /tmp/percycraft/web/mods
  cp "/opt/data/${OUTPUTS[1]}" /tmp/percycraft/web/resourcepacks/
  cd /opt/data/mods
  echo -n > /opt/percycraft/installer/downloads.iss
  echo -n > /opt/percycraft/installer/files.iss
  while read p; do
    MOD=$(ls $p*)
    cp -f /opt/data/mods/$MOD /tmp/percycraft/web/mods/
    echo "DownloadPage.Add('${FILEBUCKETWEBSITEURL}/mods/${MOD}', '${MOD}', '');" >> /opt/percycraft/installer/downloads.iss
    echo "Source: "{tmp}\\${MOD}"; DestDir: "{app}\\mods"; Flags: external" >> /opt/percycraft/installer/files.iss
  done < /opt/percycraft/mc_init/client-mods.txt
  cd /opt/percycraft
  cat << EOF > /opt/percycraft/installer/app.iss
AppVersion=$PERCYCRAFT_VERSION
AppName=Percycraft
AppPublisher=Diane Marigold
AppPublisherURL=$(git config --get remote.origin.url)
EOF
  cd -
  docker run --rm -i -v "/opt/percycraft/installer:/work" amake/innosetup percycraft.iss
  cp /opt/percycraft/installer/Output/percycraft-installer.exe /tmp/percycraft/web
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
  aws s3 cp /tmp/percycraft/web $FILEBUCKETS3URI --recursive
  rm -rf /tmp/percycraft/web
  cd /opt/percycraft/friendly-fire
  zip -r ../friendly-fire .
  cd -
  mv /opt/percycraft/friendly-fire.zip /opt/data/world/datapacks
  cp /opt/percycraft/mc_init/friendly-fire/friendlyfire.json /opt/data/config/
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
  cd /opt/percycraft/enhancedcelestials
  zip -r ../enhancedcelestials .
  cd -
  mv /opt/percycraft/enhancedcelestials.zip /opt/data/world/datapacks  
  echo $PERCYCRAFT_VERSION > /opt/data/percycraft.version
fi
chown -R 1000:1000 /opt/data
echo "Pre-start complete"
