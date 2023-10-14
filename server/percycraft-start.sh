#!/bin/bash
source /opt/.env

start-server() {
    echo Start server started >&2
    /usr/local/bin/docker-compose -f /opt/percycraft/profile/$PROFILE/docker-compose.yml --env-file /opt/data/percycraft.env up
    echo Start server complete >&2
}

start-server
