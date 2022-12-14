#!/bin/bash

cd ./minecraft

if [ ! -e eula.txt ]; then
  cp /root/require-files/* ./
fi

if [ -e version.txt ]; then
  if [ $VERSION = "void" ]; then
    if [ $(cat version.txt | awk -F. '{printf "%2d%02d%02d", $1,$2,$3}') -lt $(curl -sL https://api.purpurmc.org/v2/purpur | jq -r '.versions[-1]' | awk -F. '{printf "%2d%02d%02d", $1,$2,$3}') ]; then
      rm version.txt
      echo $(curl -sL https://api.purpurmc.org/v2/purpur | jq -r ".versions[-1]") >version.txt
      curl -sLo minecraft.jar https://api.purpurmc.org/v2/purpur/$(cat version.txt)/latest/download
    fi
  fi

  if [ $VERSION != "void" ]; then
    if [ $(echo $VERSION | awk -F. '{printf "%2d%02d%02d", $1,$2,$3}') -lt $(curl -sL https://api.purpurmc.org/v2/purpur | jq -r ".versions[-1]" | awk -F. '{printf "%2d%02d%02d", $1,$2,$3}') ]; then
      rm version.txt
      echo $(curl -sL https://api.purpurmc.org/v2/purpur | jq -r ".versions[-1]") >version.txt
      curl -sLo minecraft.jar https://api.purpurmc.org/v2/purpur/$(cat version.txt)/latest/download
    fi
  fi
fi

if [ ! -e version.txt ]; then
  if [ $VERSION =  "void" ]; then
    echo $(curl -sL https://api.purpurmc.org/v2/purpur | jq -r ".versions[-1]") >version.txt
    curl -sLo minecraft.jar https://api.purpurmc.org/v2/purpur/$(cat version.txt)/latest/download
  fi
  if [ $VERSION != "void" ]; then
    if [ $(curl -sL https://api.purpurmc.org/v2/purpur | jq -r ".versions[]|select(index(\"$VERSION\"))" | awk 'END{print}') != "" ]; then
      echo $(curl -sL https://api.purpurmc.org/v2/purpur | jq -r ".versions[]|select(index(\"$VERSION\"))" | awk 'END{print}') >version.txt
      curl -sLo minecraft.jar https://api.purpurmc.org/v2/purpur/$(cat version.txt)/latest/download
    fi
  fi
fi

rm /root/buckup.sh

curl -sLo /root/buckup.sh https://raw.githubusercontent.com/ES-Yukun/RunLatestMCJA/main/buckup.sh

chmod +x /root/buckup.sh

/root/buckup.sh &

java --add-modules=jdk.incubator.vector -Xmx$MEM -Xms$MEM -jar minecraft.jar nogui
