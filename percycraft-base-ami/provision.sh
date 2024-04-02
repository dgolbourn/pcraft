#!/bin/bash -xe
echo Provision server started >&2

provision_version() {
    git describe --tags --long --always > /opt/percycraft/percycraft.version
}

provision_docker() {
    echo Install docker started >&2
    dnf install -y docker < /dev/null
    curl -fL https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose < /dev/null
    chmod +x /usr/local/bin/docker-compose
    mkdir -p /usr/local/lib/docker/cli-plugins/
    ln -s /usr/local/bin/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose
    systemctl enable --now docker.service
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
    cp /tmp/percycraft/percycraft-base-ami/service-status.sh /opt/status/service-status.sh
    chmod +x /opt/status/service-status.sh
    cp /tmp/percycraft/percycraft-base-ami/status.service /etc/systemd/system/status.service    
    echo Install status complete >&2
}

provision_percycraft() {
    echo Install percycraft started >&2
    docker image pull amake/innosetup 
    docker image tag amake/innosetup amake/innosetup:base
    docker image pull itzg/minecraft-server
    docker image tag itzg/minecraft-server itzg/minecraft-server:base
    cp /tmp/percycraft/percycraft-base-ami/service-start.sh /opt/percycraft/service-start.sh
    cp /tmp/percycraft/percycraft-base-ami/service-stop.sh /opt/percycraft/service-stop.sh
    chmod +x /opt/percycraft/service-start.sh
    chmod +x /opt/percycraft/service-stop.sh
    cp /tmp/percycraft/percycraft-base-ami/percycraft.service /etc/systemd/system/percycraft.service   
    cp /tmp/percycraft/percycraft-base-ami/userdata.sh /opt/percycraft/userdata.sh
    chmod +x /opt/percycraft/userdata.sh 
    echo Install percycraft complete >&2
}

dnf update -y
mkdir -p /opt/percycraft
provision_version
provision_docker
provision_mcrcon
provision_mcaselector
provision_status
provision_percycraft

echo Provision server complete >&2
