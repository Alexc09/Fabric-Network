#! /bin/bash

# This script installs the chaincode

. chaincode_set_env.sh

# Encountered an issue with chaincode installation, where fabric expects hyperledger/fabric-nodeenv:2.5 but only 2.4 is publicly available on docker hub
# Solved by pulling v2.4, then re-tagging it to 2.5 (Uncomment the next 2 lines to resolve)
# docker pull hyperledger/fabric-nodeenv:2.4
# docker tag hyperledger/fabric-nodeenv:2.4 hyperledger/fabric-nodeenv:2.5


# The chaincode will be installed in the peer at the $CORE_PEER_FILESYSTEMPATH/lifecycle/chaincodes folder
peer lifecycle chaincode install $CC_PACKAGE_FILE
# peer lifecycle chaincode install simpleTx.tar.gz

# Check if the chaincode was installed on the peer filesystem
echo "Checking if the chaincode was installed on the peer:"
ls $CORE_PEER_FILESYSTEMPATH/lifecycle/chaincodes/

# Get all packages installed on the peer
# The admin executes this command against their peers
peer lifecycle chaincode queryinstalled 

# To query a specific peer listening on localhost:9051 (PeerB in our example) 
# peer lifecycle chaincode queryinstalled --peerAddresses localhost:9051