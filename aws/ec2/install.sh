#!/bin/bash
git config --global --add safe.directory /percycraft
yum update -y
yum install -y amazon-efs-utils
WWmkdir /efs
mount -t efs ${1}:/ /efs
yes | amazon-linux-extras install docker
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
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
