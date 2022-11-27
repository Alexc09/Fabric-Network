#! /bin/bash
# This script is used to set environment variables for our peer binary
# These environment variables overrides the configs in core.yaml

# NOTE THAT IN A PRODUCTION SCENARIO, EACH PEER IS ON A PHYSICALLY DIFFERENT SERVER, SO THE ENV VARIABLES CAN BE THE SAME ACROSS
# ALL PEERS (I.e All having the value CORE_PEER_FILESYSTEMPATH=$PWD/production/peer for all peers, as they'll all have their own file system)

# Checks for input argument
if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    echo "Indicate the peer to initialize (PeerA, PeerB, PeerC)"
    exit
fi

if [ "$1" == "PeerA" ]; then
    # Path of the MSP local configuration of the organization admin
    export CORE_PEER_MSPCONFIGPATH=$PWD/../crypto-config/peerOrganizations/bank_a.trade.com/users/Admin@bank_a.trade.com/msp
    # Indicate which peer you are execute your commands on
    export CORE_PEER_ADDRESS=peer0.bank_a.trade.com:7051
elif [ "$1" == "PeerB" ]; then
    export CORE_PEER_MSPCONFIGPATH=$PWD/../crypto-config/peerOrganizations/bank_b.trade.com/users/Admin@bank_b.trade.com/msp
    export CORE_PEER_ADDRESS=peer0.bank_b.trade.com:7051
elif [ "$1" == "PeerC" ]; then
    # export CORE_PEER_FILESYSTEMPATH=$PWD/../production/peer/peerC
    export CORE_PEER_MSPCONFIGPATH=$PWD/../crypto-config/peerOrganizations/bank_c.trade.com/users/Admin@bank_c.trade.com/msp
    export CORE_PEER_ADDRESS=peer0.bank_c.trade.com:7051
else
    echo "Unknown argument $1 passed!"
fi;

# Points to the folder with core.yaml. The peer binary uses this env var
export FABRIC_CFG_PATH=$PWD/../
# Controls the log verbosity (FATAL, PANIC, ERROR, WARNING, INFO, DEBUG)
export FABRIC_LOGGING_SPEC=INFO

export CORE_LEDGER_STATE_STATEDATABASE=goleveldb
export CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=testuser
export CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=testpassword

echo "Initialized environment as $1 Admin"