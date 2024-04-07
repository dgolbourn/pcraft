#!/bin/bash -xe
echo Update Enhanced Groups started >&2
mkdir -p /opt/data/config/enhancedgroups
cp /opt/percycraft/mods/enhancedgroups/persistent-groups.json /opt/data/config/enhancedgroups/
echo Update Enhanced Groups complete >&2
