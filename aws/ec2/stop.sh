#!/bin/bash
docker-compose -f /percycraft/docker-compose.mc_init.yml down
docker-compose -f /percycraft/docker-compose.mc.yml --env-file /percycraft/.env down
