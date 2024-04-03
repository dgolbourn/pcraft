#!/bin/bash

start-server() {
    echo Server started >&2
    docker compose -f /opt/percycraft/docker-compose.yml up
    echo Server complete >&2
}

start-server
