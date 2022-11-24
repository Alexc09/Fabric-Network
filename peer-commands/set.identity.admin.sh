#! /bin/bash

# This will set the identity to Admin (Based on OUs)

export CORE_PEER_MSPCONFIGPATH=$PWD/crypto-config/peerOrganizations/bank_a.trade.com/users/Admin@bank_a.trade.com/msp

echo ' Switched identity to OrgA Admin!!'
