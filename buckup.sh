#!/bin/bash

cd /root/minecraft;
while true;
  rcon -H 127.0.0.1 -p 25575 -P minecraft -m say "
Starting Backup...
If you don't have disk space left,
You should upgrade your plan.
disk usage fee: $(df . | awk '{print $5}' | grep -v "Use%")"
  do sleep 21600;
  if [ ! -d './buckup' ]; then
    mkdir ./buckup;
  fi;
  rcon -H 127.0.0.1 -p 25575 -P minecraft -m save-off
  rcon -H 127.0.0.1 -p 25575 -P minecraft -m save
  cp -R ./world ./buckup/$(date \"+"+"%s"+"\").buckup;
  cd ./buckup;
    find ./ -mtime +2 -name \"*.buckup\" -type d | xargs rm -rf;
  cd ..;
  rcon -H 127.0.0.1 -p 25575 -P minecraft -m save-on
done
