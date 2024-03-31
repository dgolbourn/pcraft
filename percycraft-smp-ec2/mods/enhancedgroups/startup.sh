#!/bin/bash -xe
echo Startup Enhanced Groups started >&2
source /opt/.env

GROUP=$(cat /opt/data/config/enhancedgroups/persistent-groups.json | jq .[0].id)
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

echo Startup Enhanced Groups complete >&2
