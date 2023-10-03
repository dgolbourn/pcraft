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

mcaselector() {
    echo Install mcaselector started >&2
    yum install -y gtk3-devel
    yum install -y xorg-x11-server-Xvfb
    curl -o javafx.tar.gz https://cdn.azul.com/zulu/bin/zulu17.30.15-ca-fx-jre17.0.1-linux_x64.tar.gz
    tar -xvzf javafx.tar.gz
    mv zulu* /opt/mca-selector
    rm javafx.tar.gz
    curl -fsSL -o mca-selector.jar https://github.com/Querz/mcaselector/releases/download/2.2.2/mcaselector-2.2.2.jar
    mv mca-selector.jar /opt/mca-selector/lib/mca-selector.jar
    echo Install mcaselector complete >&2
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
mcaselector
vector
percycraft
status

echo Provision server complete >&2
