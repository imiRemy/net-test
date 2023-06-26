#!/bin/bash

INTERFACE=enp6s16

# Set MTU for test.

sudo ifconfig $INTERFACE mtu 9000 up

# Set network buffers for test.
# These changes are lost at system restart.

sudo sysctl -w net.core.rmem_max=1024000
sudo sysctl -w net.core.wmem_max=1024000
sudo sysctl -w net.core.optmem_max=204800

