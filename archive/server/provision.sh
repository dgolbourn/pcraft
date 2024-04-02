#!/bin/bash
echo Provision server started >&2

status() {
    echo Install status started >&2
    chmod +x /opt/percycraft/server/status.sh
    cp /opt/percycraft/server/status.service /etc/systemd/system/status.service
    systemctl enable status.service
    systemctl start status.service
    echo Install status complete >&2
}

percycraft() {
    echo Install percycraft started >&2
    chmod +x /opt/percycraft/server/percycraft-install.sh
    /opt/percycraft/server/percycraft-install.sh
    chmod +x /opt/percycraft/server/percycraft-start.sh
    chmod +x /opt/percycraft/server/percycraft-stop.sh
    cp /opt/percycraft/server/percycraft.service /etc/systemd/system/percycraft.service
    systemctl enable percycraft.service
    systemctl start percycraft.service
    echo Install percycraft complete >&2
}

status
percycraft

echo Provision server complete >&2
