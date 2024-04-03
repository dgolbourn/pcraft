#!/bin/bash
echo Userdata lobby started >&2
source /opt/.env

allowlist() {
    echo "[" > /opt/lazymc/whitelist.json
    ALLOW=""
    for i in ${PLAYERLIST//,/ }
    do
        PERSON=$(curl https://api.mojang.com/users/profiles/minecraft/$i)
        ALLOW+=$PERSON,
    done
    echo ${ALLOW%,*} >> /opt/lazymc/whitelist.json
    echo "]" >> /opt/lazymc/whitelist.json
    sed -i "s/\"id\"/\"uuid\"/g" /opt/lazymc/whitelist.json
}

allowlist
systemctl enable lobby.service --now

echo Userdata lobby complete >&2
