#! /bin/bash

# This script commits the chaincode definition

. chaincode_set_env.sh


# After sufficient number of organizations have approved the chaincode definition,
# an admin from one organization submits a commit transaction

# This transaction leads to the evaluation of the lifecycle endorsement policy at runtime, checking
# whether sufficient organizations have approved the chaincode (to satisfy the endorsement policy)
# The lifecycle endorsement policy is defined by network members and is embedded in the channel genesis block

# The chaincode can only be invoked/queried if the commit transaction is successful

export CHANNEL_ID="one-bank-channel"
export ORDERER_ADDRESS=orderer.orderer_a.net:7050
export PEER_ADDRESS=peer0.bank_a.trade.com:7051

# Check which orgs have approved the chaincode definition so we know whether the chaincode definition can be committed
peer lifecycle chaincode checkcommitreadiness --name $CC_NAME --version $CC_VERSION --sequence $SEQUENCE \
--channelID $CHANNEL_ID -o $ORDERER_ADDRESS
# peer lifecycle chaincode checkcommitreadiness --name simpleTx --version 1.0 --sequence 1 \
# --channelID one-bank-channel -o localhost:7050 --init-required

# Commit the chaincode definition on the channel
peer lifecycle chaincode commit --name $CC_NAME --version $CC_VERSION --sequence $SEQUENCE \
--channelID $CHANNEL_ID -o $ORDERER_ADDRESS
# peer lifecycle chaincode commit --name simpleTx --version 1.0 --sequence 1 \
# --channelID one-bank-channel -o localhost:7050 --init-required


# Check whether the chaincode definition is committed on the channel
peer lifecycle chaincode querycommitted --channelID $CHANNEL_ID
# peer lifecycle chaincode querycommitted --name simpleTx --version 1.0 --channelID one-bank-channel