#!/bin/bash
#
# Script to reset  MTU to Jumbo frames and misc. network buffers to Ubuntu 22.04 LTS defaults.
#
# Usage: reset_mtu_buffers.sh [interface]
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

# Set interface on which to act.

if [ $# -eq 0 ] ; then
  INTERFACE=$IF_DEFAULT
else
  INTERFACE="$1"
fi

# Set MTU for to system detault; i.e. 1500

echo "Reset MTU on $INTERFACE"
sudo ifconfig $INTERFACE mtu 1500 up

# Set network buffers.

sudo sysctl -w net.core.rmem_max=212992
sudo sysctl -w net.core.wmem_max=212992
sudo sysctl -w net.core.optmem_max=20480

