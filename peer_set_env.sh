#! /bin/bash
# This script is used to set environment variables for our peer binary
# These environment variables overrides the configs in core.yaml

# Checks for input argument
if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    echo "Indicate the peer to initialize (PeerA, PeerB, PeerC)"
    exit
fi

if [ "$1" == "PeerA" ]; then
    # Where peer will store data
    export CORE_PEER_FILESYSTEMPATH=$PWD/production/peer/peerA
    export CORE_PEER_MSPCONFIGPATH=$PWD/crypto-config/peerOrganizations/bank_a.trade.com/users/Admin@bank_a.trade.com/msp
    export CORE_LEDGER_SNAPSHOTS_ROOTDIR=$PWD/production/peer/peerA/snapshots
elif [ "$1" == "PeerB" ]; then
    export CORE_PEER_FILESYSTEMPATH=$PWD/production/peer/peerB
    export CORE_PEER_MSPCONFIGPATH=$PWD/crypto-config/peerOrganizations/bank_b.trade.com/users/Admin@bank_b.trade.com/msp
    export CORE_LEDGER_SNAPSHOTS_ROOTDIR=$PWD/production/peer/peerB/snapshots
elif [ "$1" == "PeerC" ]; then
    export CORE_PEER_FILESYSTEMPATH=$PWD/production/peer/peerC
    export CORE_PEER_MSPCONFIGPATH=$PWD/crypto-config/peerOrganizations/bank_c.trade.com/users/Admin@bank_c.trade.com/msp
    export CORE_LEDGER_SNAPSHOTS_ROOTDIR=$PWD/production/peer/peerC/snapshots
fi;

# Points to the folder with core.yaml. The peer binary uses this env var
export FABRIC_CFG_PATH=$PWD
# Controls the log verbosity (FATAL, PANIC, ERROR, WARNING, INFO, DEBUG)
export FABRIC_LOGGING_SPEC=INFO

export CORE_LEDGER_STATE_STATEDATABASE=goleveldb
export CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=testuser
export CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=testpassword

echo "Initialized environment as $1"