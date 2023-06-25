#!/bin/bash

LIST="1000M 2500M 5000M 10000M"

for RATE in $LIST; do
  echo "Testing $RATE..."
  iperf3 --client 192.168.5.21 --time 30 --omit 15 --bidir --interval 0 --bitrate $RATE
done

