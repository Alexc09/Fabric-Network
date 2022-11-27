#! /bin/bash
# When upgrading the chaincode, we need to update the SEQUENCE, and the other orgs have to reapprove the new chaincode definition. The chaincode is then committed

CC_NAME=simpleTx
CC_VERSION=2.0
# sequence + 1
SEQUENCE=4
# Update the label version for version control purposes
CC_LABEL=${CC_NAME}_${CC_VERSION}
CC_PACKAGE_FILE=${CC_LABEL}.tar.gz

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