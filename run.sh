#!/bin/bash
docker_dev_up () {
    docker compose -f docker-compose.develop.yml up --build
}

docker_dev_down () {
    docker compose -f docker-compose.develop.yml down
}