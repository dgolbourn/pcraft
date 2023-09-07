#!/bin/bash
docker-compose -f docker-compose.mc_init.yml up
docker-compose -f docker-compose.mc.yml up
