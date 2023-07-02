#!/bin/bash

# Server test. Run as daemon in background.
# IP address is the interface for the server to respond on.

# Usage: server_test.sh [IP address]

# Read in default values from ".env" file.

source .env
echo "Server environment variable (default): $SERVER_IP_DEFAULT"

# Check for optionally supplied server IP address and override default if it exists.

if [ $# -eq 0 ] ; then
  IP_ADDR=$SERVER_IP_DEFAULT
else
  IP_ADDR="$1"
fi

# Check if iperf server is already running for that IP address. If so, stop and restart.

PID=$(ps -ax | grep "bind $IP_ADDR" | grep "server" | awk '{print $1;}')

if [ -z $PID ]; then
  echo "Server not running, starting..."
else
  echo "Server already running as process $PID, stopping..."
  kill $PID
  sleep 1
fi

# Deploy as daemon. Note that exit status does not return failure;
# ie. in daemon mode the command fails silently.

echo "Deploying server on $IP_ADDR as a background daemon..."

iperf3 --server --bind $IP_ADDR --daemon
sleep 1

NEW_PID=$(ps -ax | grep "bind $IP_ADDR" | grep "server" | awk '{print $1;}')

if [ -z $NEW_PID ]; then
  echo "Server not running, check IP address ($IP_ADDR)."
  exit 1
else
  echo "Server running as process $NEW_PID."
fi


