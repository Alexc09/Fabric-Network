#! /bin/bash

# This script is used to set all variables for our chaincode lifecycle

# The name of our chaincode
export CC_NAME=simpleTx
# The version of our chaincode
export CC_VERSION=1.0
# The label for our package, used to identify our packages. This label can be different across different organizations
export CC_LABEL=${CC_NAME}_${CC_VERSION}
# The name of the .tar.gz file
export CC_PACKAGE_FILE=${CC_NAME}.tar.gz
# The folder the chaincode is in
# export CC_PACKAGE_FOLDER=$PWD/bank-chaincode