#!/bin/bash -xe
echo Provision Percycraft SMP started >&2

git describe --tags --long --always > /opt/percycraft/percycraft.version
cp /tmp/percycraft/percycraft-smp-ami/update-minecraft.yml /opt/percycraft/update-minecraft.yml
cp /tmp/percycraft/percycraft-smp-ami/run-minecraft.yml /opt/percycraft/docker-compose.yml
mkdir -p /opt/percycraft/mods
cp -r /tmp/percycraft/percycraft-smp-ami/mods/enhancedgroups /opt/percycraft/mods/enhancedgroups/
chmod +x /opt/percycraft/mods/enhancedgroups/update.sh
chmod +x /opt/percycraft/mods/enhancedgroups/start.sh
cp -r /tmp/percycraft/percycraft-smp-ami/mods/friendly-fire /opt/percycraft/mods/friendly-fire/
chmod +x /opt/percycraft/mods/friendly-fire/update.sh
cp -r /tmp/percycraft/percycraft-smp-ami/mods/player-keep-inventory /opt/percycraft/mods/player-keep-inventory/
chmod +x /opt/percycraft/mods/player-keep-inventory/start.sh
cp /tmp/percycraft/percycraft-smp-ami/update.sh /opt/percycraft/update.sh
chmod +x /opt/percycraft/update.sh
cp /tmp/percycraft/percycraft-smp-ami/start.sh /opt/percycraft/start.sh
chmod +x /opt/percycraft/start.sh
cp -r /tmp/percycraft/percycraft-smp-ami/vanillatweaks /opt/percycraft/vanillatweaks
cp -r /tmp/percycraft/percycraft-smp-ami/resources /opt/percycraft/resources
/opt/percycraft/update.sh

echo Provision Percycraft SMP complete >&2
