#! /bin/bash

# https://hyperledger-fabric.readthedocs.io/en/latest/commands/peerchannel.html
# https://hyperledger-fabric.readthedocs.io/en/latest/config_update.html
# This script is used for an organization to update a channel configuration

case $1 in PeerA|PeerB|PeerC)
        echo "Launching $1"
        ;;
    *)
        echo "Expected PeerA, PeerB or PeerC as argument"
        exit 1
        ;;
esac

export CH_NAME="one-bank-channel"
export TLS_ROOT_CA="./crypto-config/peerOrganizations/bank_a.trade.com/peers/peer0.bank_a.trade.com/tls/ca.crt"
export CORE_PEER_LOCALMSPID="BankAMSP"
export CORE_PEER_MSPCONFIGPATH="./crypto-config/peerOrganizations/bank_a.trade.com/users/Admin@bank_a.trade.com/msp"
# Name of the ordering node container
# export ORDERER_CONTAINER=""

. peer_set_env.sh $1

# Retrieve the latest channel configuration
peer channel fetch config channel-artifacts/OneBankChannel/config_block.block -c $CH_NAME -o localhost:7050

# Convert the block file to a JSON version 
configtxlator proto_decode --input channel-artifacts/OneBankChannel/config_block.block --type common.Block --output channel-artifacts/OneBankChannel/config.json

# Create a copy of config.json
cp channel-artifacts/OneBankChannel/config.json channel-artifacts/OneBankChannel/modified_config.json

### ASSUME THAT modified_config.json file has been modified here

# Encode our modified_config.json file to protobuf format
configtxlator proto_encode --input channel-artifacts/OneBankChannel/config.json --type common.Config --output channel-artifacts/OneBankChannel/config.block
configtxlator proto_encode --input channel-artifacts/OneBankChannel/modified_config.json --type common.Config --output channel-artifacts/OneBankChannel/modified_config.block

# Compute the difference between the two files
configtxlator compute_update --channel-id $CH_NAME --output channel-artifacts/OneBankChannel/config_update.pb --original channel-artifacts/OneBankChannel/config.block --updated channel-artifacts/OneBankChannel/modified_config.block

# Apply the changes to the config
configtxlator proto_decode --input channel-artifacts/OneBankChannel/config_update.pb --type common.ConfigUpdate --output channel-artifacts/OneBankChannel/config_update.json
echo '{"payload":{"header":{"channel_header":{"channel_id":"'$CH_NAME'", "type":2}},"data":{"config_update":'$(cat channel-artifacts/OneBankChannel/config_update.json)'}}}' | jq . > channel-artifacts/OneBankChannel/config_update_in_envelope.json
configtxlator proto_encode --input channel-artifacts/OneBankChannel/config_update_in_envelope.json --type common.Envelope --output channel-artifacts/OneBankChannel/config_update_in_envelope.pb

# Submit config update transaction
peer channel update -f channel-artifacts/OneBankChannel/config_update_in_envelope.pb -c $CH_NAME -o localhost:7050 --tls --cafile $TLS_ROOT_CA

# The signed configuration transaction file is submitted to the network
# Transaction is sent to the orderer and distributed to peers in the network
# peer channel update -f OrgAAnchors.tx -c $CH_NAME -o localhost:7050