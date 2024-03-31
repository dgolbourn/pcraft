#!/bin/bash

start-server() {
    echo Start server started >&2
    docker compose -f /opt/docker-compose.yml up
    echo Start server complete >&2
}

start-server
