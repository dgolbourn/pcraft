#!/bin/bash
echo Provision server started >&2

provision_git() {
    dnf update -y
    dnf -y install git < /dev/null
}

provision_docker() {
    echo Install docker started >&2
    sudo dnf -y install dnf-plugins-core < /dev/null
    sudo dnf -y config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo < /dev/null
    sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin < /dev/null
    systemctl enable docker.service
    systemctl start docker.service
    echo Install docker complete >&2
}

provision_mcrcon() {
    echo Install mcrcon started >&2
    curl -fL -o mcrcon.tar.gz https://github.com/Tiiffi/mcrcon/releases/download/v0.7.2/mcrcon-0.7.2-linux-x86-64.tar.gz < /dev/null
    tar -xvzf mcrcon.tar.gz
    mv mcrcon /usr/local/bin/
    rm mcrcon.tar.gz
    chmod +x /usr/local/bin/mcrcon
    echo Install mcrcon complete >&2
}

provision_mcaselector() {
    echo Install mcaselector started >&2
    dnf install -y gtk3-devel < /dev/null
    dnf install -y xorg-x11-server-Xvfb< /dev/null
    curl -fL -o javafx.tar.gz https://cdn.azul.com/zulu/bin/zulu17.30.15-ca-fx-jre17.0.1-linux_x64.tar.gz < /dev/null
    tar -xvzf javafx.tar.gz
    mv zulu* /opt/mca-selector
    rm javafx.tar.gz
    curl -fsSL -o mca-selector.jar https://github.com/Querz/mcaselector/releases/download/2.2.2/mcaselector-2.2.2.jar < /dev/null
    mv mca-selector.jar /opt/mca-selector/lib/mca-selector.jar
    echo Install mcaselector complete >&2
}

provision_status() {
    echo Install status started >&2
    dnf install -y nc < /dev/null
    echo Install status complete >&2
}

provision_percycraft() {
    echo Install percycraft started >&2
    dnf install -y tree < /dev/null
    docker image pull amake/innosetup 
    docker image tag amake/innosetup amake/innosetup:base
    docker image pull itzg/minecraft-server
    docker image tag itzg/minecraft-server itzg/minecraft-server:base
    echo Install percycraft complete >&2
}

provision_git
provision_docker
provision_mcrcon
provision_mcaselector
provision_status
provision_percycraft

echo Provision server complete >&2
