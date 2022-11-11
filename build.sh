#!/bash/sh
# Step 1: Generate cryptographic material
cryptogen generate --config=./crypto-config.yaml --output=crypto-config

# Step 2: Create the genesis block to bootstrap the ordering service and will serve as the first block of the orderer system channel
# This block is maintained by the ordering service nodes to track the various application channels created within the network
configtxgen -profile Genesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block

# Step 3: Generate the channel configuation transactions for our two channels
configtxgen -profile AllBanksChannel -channelID all-banks-channel -outputCreateChannelTx ./channel-artifacts/AllBanksChannel/channel.tx
configtxgen -profile TwoBanksChannel -channelID two-banks-channel -outputCreateChannelTx ./channel-artifacts/TwoBanksChannel/channel.tx

# Step 4: Generate the anchor peer configuration transactions for our organizations
# This is used for cross-organization ledger syncing using the Fabric gossip protocol
# configtxen -profile AllBanksChannel -channelID all-banks-channel -outputAnchorPeersUpdate ./channel-artifacts/AllBanksChannel/BankA_anchors.tx -asOrg BankA
# configtxen -profile AllBanksChannel -channelID all-banks-channel -outputAnchorPeersUpdate ./channel-artifacts/AllBanksChannel/BankB_anchors.tx -asOrg BankB
# configtxen -profile AllBanksChannel -channelID all-banks-channel -outputAnchorPeersUpdate ./channel-artifacts/AllBanksChannel/BankC_anchors.tx -asOrg BankC

# configtxen -profile TwoBanksChannel -channelID two-banks-channel -outputAnchorPeersUpdate ./channel-artifacts/TwoBanksChannel/BankA_anchors.tx -asOrg BankA
# configtxen -profile TwoBanksChannel -channelID two-banks-channel -outputAnchorPeersUpdate ./channel-artifacts/TwoBanksChannel/BankB_anchors.tx -asOrg BankB