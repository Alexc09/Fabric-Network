Basic Steps
1. Edit the crypto-config.yaml file to configure the crypto materials to be generated
2. Edit the configtx.yaml file to configure the channel configs (E.g Channel participants, etc..) 
3. Run the generate-network-materials.sh file which uses the cryptogen tool to generate crypto material, and configtxgen tool to create the genesis block and channel configuration transactions
4. Edit the orderer.yaml file to configure the orderer
5. Using a terminal for orderer, run the orderer_launch.sh file to launch the ordering service
6. Edit the core.yaml file to configure the peer
7. Using a terminal for peer, run the peer_launch.sh file to launch the peer


Admin organization creates the channel (Assume PeerA is the admin)
1. Edit the core.yaml file to configure the peer
2. Run the peer_launch.sh file to launch the peer
3. Run the admin_create_channel.sh file to create and join the specified channel


Other organizations join the channel
1. 


Others
- Run the terminal as PeerA: . peer_set_env.sh PeerA