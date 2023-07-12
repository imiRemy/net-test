#!/bin/bash
#
# Script to change MTU to Jumbo frames and misc. network buffers.
#
# Usage: set_mtu_buffers.sh [interface]
#   where [interface] is an optionally supplied network interface name;
#   otherwise, the network interface specified in the .env file is used.
#
# NOTE: Changes made by this script are lost at system restart.
#
# Copyright (C) 2023 Remy Malan  (https://github.com/imiRemy/net-test.git)
# Permission to copy and modify is granted under the MIT license
# Last revised: 2023-07-11

source .env
echo "Interface environment variable (default): $IF_DEFAULT"

# Set interface.

if [ $# -eq 0 ] ; then
  INTERFACE=$IF_DEFAULT
else
  INTERFACE="$1"
fi

# Set MTU to Jumbo frames.

echo "Set MTU on $INTERFACE"
sudo ifconfig $INTERFACE mtu 9000 up

# Set network buffers.

sudo sysctl -w net.core.rmem_max=1024000
sudo sysctl -w net.core.wmem_max=1024000
sudo sysctl -w net.core.optmem_max=204800

