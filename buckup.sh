#!/bin/bash

cd /root/minecraft;
while true;
  rcon -H 127.0.0.1 -p 25575 -P minecraft -m say Starting Backup...
  rcon -H 127.0.0.1 -p 25575 -P minecraft -m say If you don\'t have disk space left, you should upgrade your plan.
  rcon -H 127.0.0.1 -p 25575 -P minecraft -m say Disk $(df . | awk '{print $5}')
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
  rcon -H 127.0.0.1 -p 25575 -P minecraft -m say Backup done
done
