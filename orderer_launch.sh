#! /bin/bash
# This script is used to launch the orderer

# Points to the folder with orderer.yaml. The orderer binary uses this env var
export FABRIC_CFG_PATH=$PWD

# Controls the log verbosity
export FABRIC_LOGGING_SPEC=INFO

# If you want to overwrite the configurations in orderer.yaml, you can do so via setting environment variables
# These configurations are in the format ORDERER_<SECTION>_<SUBSECTION>
# Example:
#   export ORDERER_FILELEDGER_LOCATION="/var/hyperledger/development/orderer"
#   This will overwrite the Fileledger/Location section in orderer.yaml

export ORDERER_FILELEDGER_LOCATION=$PWD/production/orderer
export ORDERER_DEBUG_BROADCASTTRACEDIR=$FABRIC_FILELEDGER_LOCATION/logs/broadcast
export ORDERER_DEBUG_BROADCASTTRACEDIR=$FABRIC_FILELEDGER_LOCATION/logs/deliver

# Launch the orderer
orderer