#!/bin/bash
[ "$(ls -A /data)" ] && [ "$(ls -A /data/mods)" ] && [ "$(ls -A /data/resourcepacks)" ] && [ "$(ls -A /data/world/datapacks)" ] && [ "$(ls -A /data/*.jar)" ] && echo "data found" || /start
