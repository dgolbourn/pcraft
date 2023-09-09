#!/bin/bash
[ "$(ls -A /data)" ] && echo "data found" || /start
