#!/bin/bash

# Server test. Run as daemon in background.
# IP address is the interface for the server to respond on.

# Usage: server_test.sh [IP address]

IP_DEFAULT="192.168.5.21"

if [ $# -eq 0 ] ; then
  IP_ADDR=$IP_DEFAULT
else
  IP_ADDR="$1"
fi

echo "Deploying server on $IP_ADDR as a background daemon."

iperf3 --server --bind $IP_ADDR --daemon

