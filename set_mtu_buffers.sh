#!/bin/bash

# Usage: set_buffers.sh [interface]
# These changes are lost at system restart.

source .env
echo "Interface environment variable (default): $IF_DEFAULT"

# Set MTU for jumbo frames.

if [ $# -eq 0 ] ; then
  INTERFACE=$IF_DEFAULT
else
  INTERFACE="$1"
fi

echo "Set MTU on $INTERFACE"
sudo ifconfig $INTERFACE mtu 9000 up

# Set network buffers.

sudo sysctl -w net.core.rmem_max=1024000
sudo sysctl -w net.core.wmem_max=1024000
sudo sysctl -w net.core.optmem_max=204800

