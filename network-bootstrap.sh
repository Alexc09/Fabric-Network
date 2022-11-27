#! /bin/bash
# Run this file in the tools container, once ./generate-network-materials.sh has been run, and the peer and orderer containers have been started

# Network bootstrap does 3 things:
# - Initializes the terminal as Organization A's admin
# - Creates and joins the one-bank-channel channel
# - Runs the simpleTx chaincode on the channel

. peer-commands/peer_set_env.sh PeerA
./peer-commands/admin_create_channel.sh PeerA
./bank-chaincode/launch_chaincode