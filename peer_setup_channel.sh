#! /bin/bash

# https://hyperledger-fabric.readthedocs.io/en/latest/commands/peerchannel.html
# This script is used to create and join a channel 

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
# -o: The orderer endpoint
# -c: The channelID which we specifed in the configtxgen command when generating the channel configuration transaction
# -f: The filepath to the channel configuration transaction file
peer channel create -o localhost:7050 -c one-bank-channel -f channel-artifacts/OneBankChannel/channel.tx --outputBlock channel-artifacts/OneBankChannel

# Join the channel, passing in the orderer endpoint and the genesis block of our channel
peer channel join -o localhost:7050 -b channel-artifacts/OneBankChannel/one-bank-channel.block

# Ensure the peer has joined the channel
peer channel list