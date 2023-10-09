#!/bin/bash
echo Provision lobby started >&2
source /opt/.env

allowlist() {
    echo "[" > /opt/lazymc/whitelist.json
    ALLOW=""
    for i in ${SMPPLAYERLIST//,/ }
    do
        PERSON=$(curl https://api.mojang.com/users/profiles/minecraft/$i)
        ALLOW+=$PERSON,
    done
    echo ${ALLOW%,*} >> /opt/lazymc/whitelist.json
    echo "]" >> /opt/lazymc/whitelist.json
    sed -i "s/\"id\"/\"uuid\"/g" /opt/lazymc/whitelist.json
}

allowlist() {
    echo "[" > /opt/lazymc/whitelist.json
    ALLOW=""
    for i in ${CREATEPLAYERLIST//,/ }
    do
        PERSON=$(curl https://api.mojang.com/users/profiles/minecraft/$i)
        ALLOW+=$PERSON,
    done
    echo ${ALLOW%,*} >> /opt/lazymc/whitelist.json
    echo "]" >> /opt/lazymc/whitelist.json
    sed -i "s/\"id\"/\"uuid\"/g" /opt/lazymc/whitelist.json
}

lazymc() {
    mkdir -p /opt/lazymc
    sudo curl -fsSL -o /opt/lazymc/lazymc https://github.com/timvisee/lazymc/releases/download/v0.2.10/lazymc-v0.2.10-linux-aarch64
    chmod +x /opt/lazymc/lazymc
}

lobby() {
    lazymc
    allowlist

    cp -r /opt/percycraft/lobby/smp /opt/smp
    chmod +x /opt/smp/server.sh
    ln -s /opt/lazymc/lazymc /opt/smp/lazymc
    ln -s /opt/lazymc/whitelist.json /opt/smp/whitelist.json
    cp /opt/percycraft/lobby/smp/lobby.service /etc/systemd/system/smp.service
    systemctl enable smp.service
    systemctl start smp.service

    cp -r /opt/percycraft/lobby/create /opt/create
    chmod +x /opt/create/server.sh
    ln -s /opt/lazymc/lazymc /opt/create/lazymc
    ln -s /opt/lazymc/whitelist.json /opt/create/whitelist.json
    cp /opt/percycraft/lobby/create/lobby.service /etc/systemd/system/create.service
    systemctl enable create.service
    systemctl start create.service
}

vector() {
    mkdir -p /opt/vector
    curl -o /opt/vector/setup.sh https://repositories.timber.io/public/vector/cfg/setup/bash.rpm.sh
    chmod +x /opt/vector/setup.sh
    /opt/vector/setup.sh
    yum install -y vector
    yum upgrade -y vector
    cp /opt/percycraft/lobby/vector.toml /etc/vector
    cp /opt/percycraft/lobby/vector.service /etc/systemd/system/vector.service
    systemctl enable vector.service
    systemctl start vector.service
}

vector
lobby
echo Provision lobby complete >&2
