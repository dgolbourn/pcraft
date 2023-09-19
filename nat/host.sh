#!/bin/bash
sed -i "s/\([^\t ]*\)\([\t ]*\)percycraft/$1\2percycraft/g" /etc/hosts
