#!/bin/bash

# Server test. Run as daemon in background.
# IP address is the interface for the server to respond on.

iperf3 --server --bind 192.168.5.21 --daemon


