#! /bin/bash

# This script packages the chaincode

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

# $CC_PACKAGE_FILE: Name of our tar.gz file
# --label: The label of our chaincode. Formatted as: <name>_<version>
# --path: The path of the folder containing the tar.gz file
# --lang: The language of our chaincode. Either node or go 
peer lifecycle chaincode package $CC_PACKAGE_FILE  --label $CC_LABEL --path $CC_PACKAGE_FOLDER --lang node