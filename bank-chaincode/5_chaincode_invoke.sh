#! /bin/bash

# This script invokes the chaincode

. chaincode_set_env.sh

export CHANNEL_ID="one-bank-channel"

# Once the chaincode is committed, applications can interact with the chaincode via 3 interfaces:
# - Init: If the chaincode was committed with --init-required flag, then Init must be executed before Query or Invoke
# - Query: The query command is executed on the local peer. The local peer reads the state of the chaincode from the local ledger
#          and sends it back as a response to the peer binary
# - Invoke: The peer binary creates the transaction proposal and sends it to the endorsing peers. 
#           The endorsing peers simulate the execution of the chaincode, endorses the trasanactions and sends it back to the peer binary
#           The peer binary then sends the endorsed transactions to the orderer
#           The orderer creates the block and delivers it to the peers in the network

# Query is used to get the endorsed result of a chaincode function call. It does not generate transactions. Used for ctx.stub.geState
# Invoke is used to invoke the chaincode. It will try to commit the endorsed trnasaction to the network. Used for ctx.stub.putState

CHANNEL_ID="one-bank-channel"

# peer chaincode instantiate --name $CC_NAME --version $CC_VERSION --channelID $CHANNEL_ID -c '{"function":"init","Args":[]}'
# peer chaincode invoke -c '{"function":"init","Args":[]}' --name $CC_NAME --channelID $CHANNEL_ID 

# Initialize the chaincode using --isInit flag (This is needed if --init-required was used in approve and commit)
peer chaincode invoke --name $CC_NAME --channelID $CHANNEL_ID --isInit -c '{"function":"init","Args":[]}'

# Query the chaincode
peer chaincode query -c '{"function":"getAllBalances","Args":[]}' --name $CC_NAME --channelID $CHANNEL_ID 
peer chaincode query -c '{"function":"getBalance","Args":["BankA"]}' --name $CC_NAME --channelID $CHANNEL_ID 

# Invokes the chaincode
peer chaincode invoke -c '{"function":"transfer","Args":["BankB","BankA","50"]}' --name $CC_NAME --channelID $CHANNEL_ID 