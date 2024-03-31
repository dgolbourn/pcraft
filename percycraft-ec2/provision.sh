#!/bin/bash -xe
echo Provision server started >&2

status() {
    echo Install Status started >&2
    chmod +x /opt/percycraft/percycraft-ec2-install/status.sh
    cp /opt/percycraft/percycraft-ec2-install/status.service /etc/systemd/system/status.service
    systemctl enable status.service
    systemctl start status.service
    echo Install Status complete >&2
}

percycraft() {
    echo Install Percycraft started >&2
    chmod +x /opt/percycraft/percycraft-ec2-install/restore-update.sh
    /opt/percycraft/percycraft-ec2-install/restore-update.sh
    /opt/startup.sh
    chmod +x /opt/percycraft/percycraft-ec2-install/start.sh
    chmod +x /opt/percycraft/percycraft-ec2-install/stop.sh
    cp /opt/percycraft/percycraft-ec2-install/percycraft.service /etc/systemd/system/percycraft.service
    systemctl enable percycraft.service
    systemctl start percycraft.service
    echo Install Percycraft complete >&2
}

status
percycraft

echo Provision server complete >&2
