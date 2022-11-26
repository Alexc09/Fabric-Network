#! /bin/bash


export PROJECT_ROOT_FOLDER=$PWD/../
# Start the docker network 
docker-compose -f docker-compose.yaml up -d