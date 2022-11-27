#! /bin/bash

# This script approves the chaincode definition

. chaincode_set_env.sh


# A chaincode definition has 2 parts: Bytecode and Parameters
# The objective of the approval process is to ensure the parameters are consistent across all organizations

# The bytecode is identified by the label + packageID
# There are 6 parameters in our chaincode definition
# - Name: The name of our chaincode
# - Version: The version of our chaincode
# - Sequence: Number of times the chaincode has been defined on a channel. Starts of as 1, and increment by 1 with every successful commit (chaincode upgrade)
# - Initialization requirements: Defines whether our chaincode needs initialization. If it needs, then chaincode cannot be invoked/queried unless it is initialized. A committed chaincode can only be initialized once
# - Private data collections
# - Chaincode endorsement policy: Defines which organizations must endorse txs before it is accepted 

# The package must be approved by the admin for use within the organization
# The approval results in the submission of a transaction, to record the approval of an organization
# The approved package is then installed onto the peer nodes


# Obtain the packageID using the queryinstalled command
echo "Running queryInstalled command to obtain packageID"
peer lifecycle chaincode queryinstalled --peerAddresses peer0.bank_a.trade.com:7051
echo "Enter packageID:"
read CC_PACKAGE_ID

export CHANNEL_ID="one-bank-channel"
export ORDERER_ADDRESS=orderer.orderer_a.net:7050
export PEER_ADDRESS=peer0.bank_a.trade.com:7051
export ORDERER_CA=crypto-config/ordererOrganizations/orderer_a.net/orderers/orderer.orderer_a.net/msp/tlscacerts/tlsca.orderer_a.net-cert.pem


# The org admin approves the chaincode
# --package-id: The package-id of the chaincode
# --name: The name of our chaincode
# --version: The version of our chaincode
# --sequence: The sequence number for the chaincode on the channel. Set to 1 when we're approving the chaincode definition for the first time
# --channelID: The ID of the channel we're approving the chaincode on
# -o: The orderer endpoint
# --init-required: Specifies whether the chaincode needs to invoke init 
peer lifecycle chaincode approveformyorg --package-id $CC_PACKAGE_ID --name $CC_NAME --version $CC_VERSION --sequence 1 --channelID $CHANNEL_ID -o $ORDERER_ADDRESS --peerAddresses $PEER_ADDRESS
# --tls --cafile $ORDERER_CA

# peer lifecycle chaincode approveformyorg --package-id simpleTx_1.0:e676806cabce61eb02b2547fe6753ddb7a5aadc4511e3e975419db485195235d \
# --name simpleTx --version 1.0 --sequence 1 --channelID one-bank-channel -o localhost:7050 --init-required


# Query the organization's approved chaincode definition
peer lifecycle chaincode queryapproved --name $CC_NAME --channelID $CHANNEL_ID
# peer lifecycle chaincode queryapproved --name simpleTx --channelID one-bank-channel