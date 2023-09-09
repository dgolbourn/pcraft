#!/bin/bash
yum update -y
yum install -y amazon-efs-utils
mkdir /efs
mount -t efs ${1}:/ /efs
yes | amazon-linux-extras install docker
yum erase amazon-ssm-agent -y
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
curl -fsSL -o mcaselector.jar https://github.com/Querz/mcaselector/releases/download/2.2.2/mcaselector-2.2.2.jar        
mv mcaselector.jar /usr/local/bin/mcaselector.jar
chmod +x /usr/local/bin/mcaselector.jar
curl -fsSL -o mcrcon.tar.gz https://github.com/Tiiffi/mcrcon/releases/download/v0.7.2/mcrcon-0.7.2-linux-x86-64.tar.gz  
tar -xvzf mcrcon.tar.gz
mv mcrcon /usr/local/bin/
rm mcrcon.tar.gz
chmod +x /usr/local/bin/mcrcon
mkdir -p /efs/data
mkdir -p /efs/backups
mkdir -p /efs/web
ln -sf /efs/data/resourcepacks /efs/web/resourcepacks
ln -sf /efs/data/mods /efs/web/mods
chmod +x /percycraft/mc_init/init.sh
chmod +x /percycraft/mc_init/pre-start.sh
mv /percycraft/aws/ec2/percycraft.service /etc/systemd/system/percycraft.service
systemctl enable docker.service
systemctl enable percycraft.service
systemctl start docker.service
systemctl start percycraft.service
