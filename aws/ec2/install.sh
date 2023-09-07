#!/bin/bash
sudo amazon-linux-extras install docker
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo yum -y install git
git clone https://github.com/dgolbourn/percycraft.git
sudo mkdir -p /efs/data
sudo mkdir -p /efs/backups
sudo mkdir -p /efs/web
sudo chown -R ec2-user:ec2-user /efs
sudo systemctl start docker
sudo usermod -aG docker ec2-user
sudo curl -fsSL -o mcaselector.jar https://github.com/Querz/mcaselector/releases/download/2.2.2/mcaselector-2.2.2.jar
sudo mv mcaselector-2.2.2.jar /usr/local/bin/mcaselector.jar
sudo chmod +x /usr/local/bin/mcaselector.jar
sudo curl -fsSL -o mcrcon.tar.gz https://github.com/Tiiffi/mcrcon/releases/download/v0.7.2/mcrcon-0.7.2-linux-x86-64.tar.gz
sudo tar -xvzf mcrcon.tar.gz
sudo mv mcrcon /usr/local/bin/
sudo rm mcrcon.tar.gz
sudo chmod +x /usr/local/bin/mcrcon
