#! /bin/bash

# This script packages the chaincode

# ENSURE THAT peer_set_env.sh has been run in the ROOT FOLDER (I.e up 1 path from the /bank-chaincode folder)
# YOU NEED TO CONFIGURE FABRIC_CFG_PATH FIRST

. chaincode_set_env.sh

# $CC_PACKAGE_FILE: Name of our tar.gz file
# --label: The label of our chaincode. Formatted as: <name>_<version>
# --path: The path of the folder containing our chaincode
# --lang: The language of our chaincode. Either node or go 
peer lifecycle chaincode package $CC_PACKAGE_FILE --label $CC_LABEL --path . --lang node

# peer lifecycle chaincode package simpleTx.tar.gz --label simpleTx_1.0 --path . --lang node