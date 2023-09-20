#!/bin/bash
yum install -y iptables-services
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p 
iptables -t nat -A POSTROUTING -j MASQUERADE
iptables -t nat -A PREROUTING -p udp --dport 24454 -j DNAT --to-destination 18.169.42.16:24454 
service iptables save 
mkdir -p /opt/lazymc
sudo curl -fsSL -o /opt/lazymc/lazymc https://github.com/timvisee/lazymc/releases/download/v0.2.10/lazymc-v0.2.10-linux-aarch64
chmod +x /opt/lazymc/lazymc
chmod +x /opt/percycraft/nat/server.sh
cp /opt/percycraft/nat/server.sh /opt/lazymc
cp /opt/percycraft/nat/lazymc.toml /opt/lazymc
cp /opt/percycraft/nat/lobby.service /etc/systemd/system/lobby.service            
systemctl enable lobby.service
systemctl start lobby.service
