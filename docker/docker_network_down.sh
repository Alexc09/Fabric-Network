#! /bin/bash

export PROJECT_ROOT_FOLDER=$PWD/../

# Remove volumes created by docker compose
docker-compose down --volumes