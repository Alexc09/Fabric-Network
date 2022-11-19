#! /bin/bash

# This script installs the chaincode

case $1 in PeerA|PeerB|PeerC)
        echo "Launching $1"
        ;;
    *)
        echo "Expected PeerA, PeerB or PeerC as argument"
        exit 1
        ;;
esac

. ../peer_set_env.sh $1
. chaincode_set_env.sh


# The chaincode will be installed in the peer at the $CORE_PEER_FILESYSTEMPATH/lifecycle folder
peer lifecycle chaincode install $CC_PACKAGE_FILE

# Check if the chaincode was installed on the peer filesystem
echo "Checking if the chaincode was installed on the peer:"
ls $CORE_PEER_FILESYSTEMPATH/lifecycle/chaincodes/

# Get all packages installed on the peer
# The admin executes this command against their peers
peer lifecycle chaincode queryinstalled 

# To query a specific peer listening on localhost:9051 (PeerB in our example) 
# peer lifecycle chaincode queryinstalled --peerAddresses localhost:9051