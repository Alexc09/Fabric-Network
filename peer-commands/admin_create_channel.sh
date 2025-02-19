#! /bin/bash

# https://hyperledger-fabric.readthedocs.io/en/latest/commands/peerchannel.html
# This script is used for the admin organization to create a channel and join it

case $1 in PeerA|PeerB|PeerC)
        echo "Launching $1"
        ;;
    *)
        echo "Expected PeerA, PeerB or PeerC as argument"
        exit 1
        ;;
esac

. peer_set_env.sh $1

# Create the channel, which outputs a genesis block of our channel
# -o: The orderer endpoint. Use the docker container name of the orderer
# -c: The channelID which we specifed in the configtxgen command when generating the channel configuration transaction
# -f: The filepath to the channel configuration transaction file
peer channel create -o orderer.orderer_a.net:7050 -c one-bank-channel -f ../channel-artifacts/OneBankChannel/channel.tx --outputBlock ../channel-artifacts/OneBankChannel/one-bank-channel.block

# Set CORE_PEER_ADDRESS env var to point to peerA using container name (This is done in peer_set_env.sh)
# export CORE_PEER_ADDRESS=peer0.bank_a.trade.com:7051

# Join the channel, passing in the orderer endpoint and the genesis block of our channel
peer channel join -o orderer.orderer_a.net:7050 -b ../channel-artifacts/OneBankChannel/one-bank-channel.block

# Ensure the peer has joined the channel
peer channel list