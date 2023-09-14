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
chmod +x /opt/percycraft/aws/ec2/restore.sh
chmod +x /opt/percycraft/aws/ec2/pre-start.sh
chmod +x /opt/percycraft/aws/ec2/backup.sh
cp /opt/percycraft/aws/ec2/percycraft.service /etc/systemd/system/percycraft.service
systemctl enable docker.service
systemctl enable percycraft.service
systemctl start docker.service
systemctl start percycraft.service
echo "Install complete"
