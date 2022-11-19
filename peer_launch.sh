#! /bin/bash
# This script is used to launch the peer
# https://hyperledger-fabric.readthedocs.io/en/latest/commands/peercommand.html

case $1 in PeerA|PeerB|PeerC)
        echo "Launching $1"
        ;;
    *)
        echo "Expected PeerA, PeerB or PeerC as argument"
        exit 1
        ;;
esac

# Initialize environment variables for our peer. The dot in front is shorthand for source, which ensures the env variables 
# are initialized in our current shell
# . peer_set_env.sh PeerA
. peer_set_env.sh $1

# Launch the peer
peer node start