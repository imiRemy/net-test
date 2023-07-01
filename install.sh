#!/bin/bash

# net-test installation.

# Update OS and get basic modules.

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install net-tools iperf3

# If you want to run remote commands to control the server machine,
# then also install SSH. To manually run on both client and server,
# installing the SSH server can be commented out.
# NOTE: this script does *not* start the SSH server.

sudo apt-get -y install openssh-server

# Make sure the ufw firewall is installed.
# Enable the firewall, allow SSH and the iperf3 server port read in
# from the .env environment variables file.

sudo apt-get -y install ufw

echo "Setting up ufw firewall..."
source .env
sudo ufw allow ssh
sudo ufw allow $IPERF_SERVER_PORT
sudo ufw enable

