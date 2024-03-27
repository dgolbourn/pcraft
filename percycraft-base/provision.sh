#!/bin/bash
echo Provision server started >&2

git() {
    dnf update -y
    dnf -y install git < /dev/null
}

docker() {
    echo Install docker started >&2
    dnf install -y docker < /dev/null
    curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose < /dev/null
    chmod +x /usr/local/bin/docker-compose
    systemctl enable docker.service
    systemctl start docker.service
    echo Install docker complete >&2
}

mcrcon() {
    echo Install mcrcon started >&2
    curl -fsSL -o mcrcon.tar.gz https://github.com/Tiiffi/mcrcon/releases/download/v0.7.2/mcrcon-0.7.2-linux-x86-64.tar.gz < /dev/null
    tar -xvzf mcrcon.tar.gz
    mv mcrcon /usr/local/bin/
    rm mcrcon.tar.gz
    chmod +x /usr/local/bin/mcrcon
    echo Install mcrcon complete >&2
}

mcaselector() {
    echo Install mcaselector started >&2
    dnf install -y gtk3-devel < /dev/null
    dnf install -y xorg-x11-server-Xvfb< /dev/null
    curl -o javafx.tar.gz https://cdn.azul.com/zulu/bin/zulu17.30.15-ca-fx-jre17.0.1-linux_x64.tar.gz < /dev/null
    tar -xvzf javafx.tar.gz
    mv zulu* /opt/mca-selector
    rm javafx.tar.gz
    curl -fsSL -o mca-selector.jar https://github.com/Querz/mcaselector/releases/download/2.2.2/mcaselector-2.2.2.jar < /dev/null
    mv mca-selector.jar /opt/mca-selector/lib/mca-selector.jar
    echo Install mcaselector complete >&2
}

statusbase() {
    echo Install status started >&2
    dnf install -y nc < /dev/null
    echo Install status complete >&2
}

percycraftbase() {
    echo Install percycraft started >&2
    dnf install -y tree < /dev/null
    docker pull amake/innosetup 
    docker tag amake/innosetup amake/innosetup:base
    docker pull itzg/minecraft-server
    docker tag itzg/minecraft-server itzg/minecraft-server:base
    echo Install percycraft complete >&2
}

git
docker
percycraftbase
mcrcon
mcaselector
statusbase

echo Provision server complete >&2
