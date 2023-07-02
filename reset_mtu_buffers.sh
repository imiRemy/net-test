#!/bin/bash

# Usage: reset_buffers.sh [interface]
# Restore default settings.
# Note: These changes are lost at system restart.

source .env
echo "Interface environment variable (default): $IF_DEFAULT"

# Set MTU for jumbo frames.

if [ $# -eq 0 ] ; then
  INTERFACE=$IF_DEFAULT
else
  INTERFACE="$1"
fi

echo "Reset MTU on $INTERFACE"
sudo ifconfig $INTERFACE mtu 1500 up

# Set network buffers.

sudo sysctl -w net.core.rmem_max=212992
sudo sysctl -w net.core.wmem_max=212992
sudo sysctl -w net.core.optmem_max=20480

