#!/bin/bash -xe
echo update friendly-fire started >&2
cd /opt/percycraft/mods/friendly-fire/friendly-fire
zip -r ../friendly-fire .
cp /opt/percycraft/mods/friendly-fire/friendly-fire.zip /opt/data/world/datapacks
cp /opt/percycraft/mods/friendly-fire/friendlyfire.json /opt/data/config/
echo update friendly-fire complete >&2
