#!/bin/bash
# This script is used to generate the crypto material + genesis block + channel config txs

# #### READ THIS IF ENCOUNTER ERROR TRYING TO GENERATE CRYPTO MATERIAL ####
# If you get the below error:
# Error generating signCA for org bank_a.trade.com
# Restart WSL. This bug seems to appear due to windows filesystem & wsl filesystem being out of sync, when you delete a folder using windows and try to create it via wsl
# To avoid this issue, delete the folder using wsl rm -r command, instead of manually deleting it in windows explorer
# If the issue still persists, delete this project & re-clone it from github

# Delete the existing configs
rm -r crypto-config channel-artifacts-output channel-artifacts

# Delete the existing blockchain network files
# rm -r production

# Points to the folder with configtx.yaml (In this case, it's PWD because this file and configtx.yaml are in the same folder)
export FABRIC_CFG_PATH=$PWD

# Step 1: Generate cryptographic material
cryptogen generate --config=./crypto-config.yaml --output=crypto-config

# Step 2: Create the genesis block to bootstrap the ordering service and will serve as the first block of the orderer system channel
# This block is maintained by the ordering service nodes to track the various application channels created within the network
configtxgen -profile Genesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block

# Step 3: Generate the channel configuation transactions for our three channels
configtxgen -profile AllBanksChannel -channelID all-banks-channel -outputCreateChannelTx ./channel-artifacts/AllBanksChannel/channel.tx
configtxgen -profile TwoBanksChannel -channelID two-banks-channel -outputCreateChannelTx ./channel-artifacts/TwoBanksChannel/channel.tx
configtxgen -profile OneBankChannel -channelID one-bank-channel -outputCreateChannelTx ./channel-artifacts/OneBankChannel/channel.tx

ARTIFACT_OUTPUT_DIR="./channel-artifacts-output"
if [ ! -d $ARTIFACT_OUTPUT_DIR ]; then
    echo "Creating drectory ${ARTIFACT_OUTPUT_DIR}"
    mkdir $ARTIFACT_OUTPUT_DIR
fi

configtxgen -inspectBlock ./channel-artifacts/genesis.block > ./channel-artifacts-output/genesis.json
configtxgen -inspectChannelCreateTx ./channel-artifacts/AllBanksChannel/channel.tx > ./channel-artifacts-output/AllBanksChannelTx.json
configtxgen -inspectChannelCreateTx ./channel-artifacts/TwoBanksChannel/channel.tx > ./channel-artifacts-output/TwoBanksChannelTx.json
configtxgen -inspectChannelCreateTx ./channel-artifacts/OneBankChannel/channel.tx > ./channel-artifacts-output/OneBankChannelTx.json

# Step 4: Generate the anchor peer configuration transactions for our organizations
# This is used for cross-organization ledger syncing using the Fabric gossip protocol
# configtxen -profile AllBanksChannel -channelID all-banks-channel -outputAnchorPeersUpdate ./channel-artifacts/AllBanksChannel/BankA_anchors.tx -asOrg BankA
# configtxen -profile AllBanksChannel -channelID all-banks-channel -outputAnchorPeersUpdate ./channel-artifacts/AllBanksChannel/BankB_anchors.tx -asOrg BankB
# configtxen -profile AllBanksChannel -channelID all-banks-channel -outputAnchorPeersUpdate ./channel-artifacts/AllBanksChannel/BankC_anchors.tx -asOrg BankC

# configtxen -profile TwoBanksChannel -channelID two-banks-channel -outputAnchorPeersUpdate ./channel-artifacts/TwoBanksChannel/BankA_anchors.tx -asOrg BankA
# configtxen -profile TwoBanksChannel -channelID two-banks-channel -outputAnchorPeersUpdate ./channel-artifacts/TwoBanksChannel/BankB_anchors.tx -asOrg BankB