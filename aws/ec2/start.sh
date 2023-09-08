#!/bin/bash
docker-compose -f /percycraft/docker-compose.mc_init.yml up
docker-compose -f /percycraft/docker-compose.mc.yml up
