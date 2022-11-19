#! /bin/bash
# This script is used to launch the peer
# https://hyperledger-fabric.readthedocs.io/en/latest/commands/peercommand.html

# Points to the folder with core.yaml. The peer binary uses this env var
export FABRIC_CFG_PATH=$PWD

# Controls the log verbosity (FATAL, PANIC, ERROR, WARNING, INFO, DEBUG)
export FABRIC_LOGGING_SPEC=INFO

# If you want to overwrite the configurations in orderer.yaml, you can do so via setting environment variables
# These configurations are in the format ORDERER_<SECTION>_<SUBSECTION>
# Example:
#   export ORDERER_FILELEDGER_LOCATION="/var/hyperledger/development/orderer"
#   This will overwrite the Fileledger/Location section in orderer.yaml

# Where peer will store data
export CORE_PEER_FILESYSTEMPATH=$PWD/production/peer/peerA
export CORE_PEER_MSPCONFIGPATH=$PWD/crypto-config/peerOrganizations/bank_a.trade.com/users/Admin@bank_a.trade.com/msp

export CORE_LEDGER_SNAPSHOTS_ROOTDIR=$PWD/production/peer/peerA/snapshots
export CORE_LEDGER_STATE_STATEDATABASE=goleveldb
export CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=testuser
export CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=testpassword

# Launch the orderer
peer node start