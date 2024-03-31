#!/bin/bash -xe
echo friendly-fire started >&2
cd /opt/percycraft/mods/friendly-fire/friendly-fire
zip -r ../friendly-fire .
mv /opt/percycraft/mods/friendly-fire/friendly-fire.zip /opt/data/world/datapacks
cp /opt/percycraft/mods/friendly-fire/friendlyfire.json /opt/data/config/
echo friendly-fire complete >&2
