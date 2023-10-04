#!/bin/bash
echo Provision server started >&2

docker() {
    echo Install docker started >&2
    yum install -y docker
    curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    systemctl enable docker.service
    systemctl start docker.service
    echo Install docker complete >&2
}

mcrcon() {
    echo Install mcrcon started >&2
    curl -fsSL -o mcrcon.tar.gz https://github.com/Tiiffi/mcrcon/releases/download/v0.7.2/mcrcon-0.7.2-linux-x86-64.tar.gz
    tar -xvzf mcrcon.tar.gz
    mv mcrcon /usr/local/bin/
    rm mcrcon.tar.gz
    chmod +x /usr/local/bin/mcrcon
    echo Install mcrcon complete >&2
}

vector() {
    echo Install vector started >&2
    mkdir -p /opt/vector
    curl -o /opt/vector/setup.sh https://repositories.timber.io/public/vector/cfg/setup/bash.rpm.sh
    chmod +x /opt/vector/setup.sh
    /opt/vector/setup.sh
    yum install -y vector
    yum upgrade -y vector
    cp /opt/percycraft/server/vector.toml /etc/vector
    cp /opt/percycraft/server/vector.service /etc/systemd/system/vector.service
    systemctl enable vector.service
    systemctl start vector.service
    echo Install vector complete >&2
}

percycraft() {
    echo Install percycraft started >&2
    mkdir -p /opt/data
    yum install -y tree
    chmod +x /opt/percycraft/server/percycraft-install.sh
    /opt/percycraft/server/percycraft-install.sh
    chmod +x /opt/percycraft/server/percycraft-start.sh
    chmod +x /opt/percycraft/server/percycraft-stop.sh
    chmod +x /opt/percycraft/server/force-stop.sh
    cp /opt/percycraft/server/percycraft.service /etc/systemd/system/percycraft.service
    systemctl enable percycraft.service
    systemctl start percycraft.service
    echo Install percycraft complete >&2
}

status() {
    echo Install status started >&2
    yum install -y nc
    chmod +x /opt/percycraft/server/status.sh
    cp /opt/percycraft/server/status.service /etc/systemd/system/status.service
    systemctl enable status.service
    systemctl start status.service
    echo Install status complete >&2
}

docker
mcrcon
vector
percycraft
status

echo Provision server complete >&2
