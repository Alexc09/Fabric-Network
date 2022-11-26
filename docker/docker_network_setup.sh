#! /bin/bash


export PROJECT_ROOT_FOLDER=$PWD/../

# Start a single service
# Start the tools service as a standalone during the very first setup. We use the tools container to generate our crypto material + genesis block
# docker-compose up -d tools

# Start the docker network 
docker-compose -f docker-compose.yaml up -d