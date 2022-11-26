#! /bin/bash

# Edit CA Service parameters via environment variables
# These configurations appear in fabric-ca-server-config.yaml but can be overwritten with environment variables
# export FABRIC_CA_SERVER_PORT=7054

# Start the CA service
# -b: The identity used to bootstrap the ca server. Passed in via <username>:<password> form
# --home: The CA server's home directory, which stores the keys, configurations and database of the CA
fabric-ca-server start -b admin:adminpw --home ./ca-server