#!/bin/bash
echo "Install started"

apt update -y
apt install -y nfs-common
mkdir -p /efs
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport 10.100.0.7:/ /efs

git clone https://github.com/dgolbourn/percycraft.git /opt/percycraft

apt update -y
apt install -y apt-transport-https software-properties-common
apt install -y ca-certificates
wget -O "/usr/share/keyrings/xpra.asc" https://xpra.org/xpra.asc
wget -O "/etc/apt/sources.list.d/xpra.sources" https://xpra.org/repos/jammy/xpra.sources
apt -y update
apt -y install xpra

curl -o javafx.tar.gz https://cdn.azul.com/zulu/bin/zulu17.30.15-ca-fx-jre17.0.1-linux_x64.tar.gz
tar -xvzf javafx.tar.gz
mv zulu* /opt/mca-selector
rm javafx.tar.gz
curl -fsSL -o mca-selector.jar https://github.com/Querz/mcaselector/releases/download/2.2.2/mcaselector-2.2.2.jar        
mv mca-selector.jar /opt/mca-selector/lib/mca-selector.jar

cp /opt/percycraft/aws/mcas/mcas.service /etc/systemd/system/mcas.service
chmod +x /opt/percycraft/aws/backup/restore.sh
chmod +x /opt/percycraft/aws/backup/backup.sh
systemctl enable mcas.service
systemctl start mcas.service

echo "Install complete"
