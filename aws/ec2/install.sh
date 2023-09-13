#!/bin/bash
git config --global --add safe.directory /percycraft
yum update -y
yum install -y amazon-efs-utils
yum install -y xorg-x11-xauth
WWmkdir /efs
mount -t efs ${1}:/ /efs
yes | amazon-linux-extras install docker
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
curl -o javafx.tar.gz https://cdn.azul.com/zulu/bin/zulu17.30.15-ca-fx-jre17.0.1-linux_x64.tar.gz
tar -xvzf javafx.tar.gz
mv zulu* /opt/mca-selector
rm javafx.tar.gz
curl -fsSL -o mca-selector.jar https://github.com/Querz/mcaselector/releases/download/2.2.2/mcaselector-2.2.2.jar        
mv mca-selector.jar /opt/mca-selector/lib/mca-selector.jar
curl -fsSL -o mcrcon.tar.gz https://github.com/Tiiffi/mcrcon/releases/download/v0.7.2/mcrcon-0.7.2-linux-x86-64.tar.gz  
tar -xvzf mcrcon.tar.gz
mv mcrcon /usr/local/bin/
rm mcrcon.tar.gz
chmod +x /usr/local/bin/mcrcon
mkdir -p /efs/data
mkdir -p /efs/backups
mkdir -p /efs/web
chmod +x /percycraft/mc_init/init.sh
chmod +x /percycraft/mc_init/pre-start.sh
cp /percycraft/aws/ec2/percycraft.service /etc/systemd/system/percycraft.service
systemctl enable docker.service
systemctl enable percycraft.service
systemctl start docker.service
systemctl start percycraft.service
