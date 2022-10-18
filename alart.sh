#!/bin/bash

while true; do
  if [ $(echo "$(ps -C java -o %cpu | grep -v "%CPU") > 90" | bc ) -eq 1 ]; then
    rcon -H 127.0.0.1 -p 25575 -P minecraft -m say WARNING: CPU usage over 100%
  fi;
  sleep 1
done