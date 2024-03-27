#!/bin/bash -xe
echo Install server started >&2

cd /opt/percycraft
mkdir -p /opt/data
git describe --tags --long --always > /opt/data/percycraft.version
/usr/local/bin/docker-compose -f /opt/percycraft/percycraft-smp/install-minecraft.yml up
rm -rf /opt/data/.modrinth-manifest.json
chmod +x /opt/percycraft/mods/enhancedgroups/provision.sh
chmod +x /opt/percycraft/mods/friendly-fire/provision.sh
/opt/percycraft/mods/enhancedgroups/provision.sh
/opt/percycraft/mods/friendlyfire/provision.sh
chown -R 1000:1000 /opt/data

echo Install server complete >&2
