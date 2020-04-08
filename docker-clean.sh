#!/bin/bash

docker system prune -a -f
docker volume prune -f
docker image prune -a -f