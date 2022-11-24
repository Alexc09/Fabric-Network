#! /bin/bash

# https://hyperledger-fabric.readthedocs.io/en/latest/commands/peerchannel.html
# This script is used for other peers to join an already created channel

case $1 in PeerA|PeerB|PeerC)
        echo "Launching $1"
        ;;
    *)
        echo "Expected PeerA, PeerB or PeerC as argument"
        exit 1
        ;;
esac

. peer_set_env.sh $1

# Retrieve the specified block from the ordering service

# "config" will retrieve the latest block on that channel
peer channel fetch test.pb config -c one-bank-channel -o localhost:7050
# The 0-th block is the genesis block
# peer channel fetch 0 -c one-bank-channel -o localhost:7050

# Join the channel
peer channel join -o localhost:7050 -b channel-artifacts/OneBankChannel/one-bank-channel.block

# Get channel info (Block height & hash)
peer channel getinfo -c one-bank-channel