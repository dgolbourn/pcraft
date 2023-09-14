#!/bin/bash
echo "Install started"
yum install -y docker
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
curl -fsSL -o mcrcon.tar.gz https://github.com/Tiiffi/mcrcon/releases/download/v0.7.2/mcrcon-0.7.2-linux-x86-64.tar.gz  
tar -xvzf mcrcon.tar.gz
mv mcrcon /usr/local/bin/
rm mcrcon.tar.gz
chmod +x /usr/local/bin/mcrcon
mkdir -p /opt/data
mkdir -p /efs/backups
mkdir -p /opt/web
chmod +x /opt/pcraft/aws/ec2/restore.sh
chmod +x /opt/pcraft/aws/ec2/pre-start.sh
chmod +x /opt/pcraft/aws/ec2/backup.sh
cp /opt/pcraft/aws/ec2/pcraft.service /etc/systemd/system/pcraft.service
systemctl enable docker.service
systemctl enable pcraft.service
systemctl start docker.service
systemctl start pcraft.service
echo "Install complete"
