#! /bin/bash
# This file launches the chaincode for the very first time. Subsequent updates will use the update_local_chaincode.sh or upgrade_chaincode.sh file

CC_NAME=simpleTx
CC_VERSION=1.0
CC_LABEL=${CC_NAME}_${CC_VERSION}
CC_PACKAGE_FILE=${CC_LABEL}.tar.gz

SEQUENCE=1
CHANNEL_ID="one-bank-channel"
ORDERER_ADDRESS=orderer.orderer_a.net:7050
PEER_ADDRESS=peer0.bank_a.trade.com:7051

peer lifecycle chaincode package $CC_PACKAGE_FILE --label $CC_LABEL --path . --lang node
peer lifecycle chaincode install -o orderer.orderer_a.net:7050 --peerAddresses peer0.bank_a.trade.com:7051 $CC_PACKAGE_FILE

# Obtain the packageID using the queryinstalled command
echo "Running queryInstalled command to obtain packageID"
peer lifecycle chaincode queryinstalled --peerAddresses peer0.bank_a.trade.com:7051
echo "Enter packageID:"
read CC_PACKAGE_ID
peer lifecycle chaincode approveformyorg --package-id $CC_PACKAGE_ID --name $CC_NAME --version $CC_VERSION --sequence $SEQUENCE --channelID $CHANNEL_ID -o $ORDERER_ADDRESS --peerAddresses $PEER_ADDRESS --init-required

peer lifecycle chaincode checkcommitreadiness --name $CC_NAME --version $CC_VERSION --sequence $SEQUENCE --channelID $CHANNEL_ID -o $ORDERER_ADDRESS
peer lifecycle chaincode commit --name $CC_NAME --version $CC_VERSION --sequence $SEQUENCE --channelID $CHANNEL_ID -o $ORDERER_ADDRESS --init-required
peer lifecycle chaincode querycommitted --channelID $CHANNEL_ID

# Run the chaincode init() function to populate our state
peer chaincode invoke --name $CC_NAME --channelID $CHANNEL_ID --isInit -c '{"function":"init","Args":[]}'