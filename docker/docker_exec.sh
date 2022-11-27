#! /bin/bash

# When running peer commands via the tools container, remember to set the environment variables to the peer you're running as (I.e CORE_PEER_MSPCONFIGPATH)
docker exec -it tools /bin/bash
# docker exec -it peerA /bin/sh
# docker exec -it ordererA /bin/sh