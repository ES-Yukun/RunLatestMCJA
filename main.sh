#!/bin/bash

cd /root/minecraft
INSTALLVER=void
if [ $STATICVER != "void" ]; then
  echo "Checking Version ($(echo $STATICVER))"
  if [ ! -e version.txt ]; then
    touch version.txt
  fi
  if [ $(cat version.txt) != $STATICVER ]; then
    if [ $(curl -sL https://api.purpurmc.org/v2/purpur | jq -r ".versions[]|select(index(\"$STATICVER\"))" | awk 'END{print}') != "" ]; then
      rm version.txt
      echo $(curl -sL https://api.purpurmc.org/v2/purpur | jq -r ".versions[]|select(index(\"$STATICVER\"))" | awk 'END{print}') > version.txt
    fi
INSTALLVER=$(cat version.txt)
  fi 
fi
if [ $STATICVER = "void" ]; then
  if [ ! -e version.txt ]; then
    touch version.txt
  fi
  if [ $(cat version.txt) !=  $(curl -sL https://api.purpurmc.org/v2/purpur | jq -r ".versions[-1]") ]; then
    rm version.txt
    echo $(curl -sL https://api.purpurmc.org/v2/purpur | jq -r ".versions[-1]") > version.txt
INSTALLVER=$(cat version.txt)
  fi
fi
if [ $INSTALLVER != "void" ]; then 
  rm minecraft.jar
  curl -sLo minecraft.jar https://api.purpurmc.org/v2/purpur/$(echo $INSTALLVER)/latest/download
fi
/root/buckup.sh &
java --add-modules=jdk.incubator.vector -Xmx$MEM -Xms$MEM -jar minecraft.jar nogui