#!/bin/bash -xe
echo Install Enhanced Groups started >&2
mkdir -p /opt/data/config/enhancedgroups
cp /opt/percycraft/percycraft-smp-ami/mods/enhancedgroups/persistent-groups.json /opt/data/config/enhancedgroups/
echo Install Enhanced Groups complete >&2
