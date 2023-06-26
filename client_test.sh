#!/bin/bash

# Usage: client_test.sh [IP address]

IP_DEFAULT="192.168.5.21"
LIST="1000M 2500M 5000M 10000M"
LOG_FILE="/tmp/net-test-$(date +%Y-%m-%d-%H%M.%S).txt"

if [ $# -eq 0 ] ; then
  IP_ADDR=$IP_DEFAULT
else
  IP_ADDR="$1"
fi

echo "Logging results for $IP_ADDR in $LOG_FILE"
echo "$0: Test results on $IP_ADDR" >> $LOG_FILE

for RATE in $LIST; do
  echo "Testing $RATE..."
  iperf3 --client $IP_ADDR --time 30 --omit 15 --bidir --interval 0 --bitrate $RATE --logfile $LOG_FILE
done

