#!/bin/bash
mkdir -p /opt/lazymc
sudo curl -fsSL -o /opt/lazymc/lazymc https://github.com/timvisee/lazymc/releases/download/v0.2.10/lazymc-v0.2.10-linux-aarch64
chmod +x /opt/lazymc/lazymc
chmod +x /opt/percycraft/nat/server.sh
cp /opt/percycraft/nat/server.sh /opt/lazymc
cp /opt/percycraft/nat/lazymc.toml /opt/lazymc
cp /opt/percycraft/nat/lobby.service /etc/systemd/system/lobby.service            
systemctl enable lobby.service
systemctl start lobby.service
