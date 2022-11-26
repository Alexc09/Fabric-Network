#! /bin/bash


# Location of the fabric-ca-client-config.yaml file
# export FABRIC_CA_CLIENT_HOME=$PWD
# -h: Home folder, location of the fabric-ca-client-config.yaml file

# Enroll our admin user (the bootstrap user we defined when launching our CA service)
fabric-ca-client enroll -u http://admin:adminpw@localhost:7054 --home "$PWD/ca-client"