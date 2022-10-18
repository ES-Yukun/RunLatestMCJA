FROM archlinux:latest

ENV MEM=1G
ENV RCONPASSWD=minecraft
ENV VERSION=void

WORKDIR /root
RUN mkdir /root/minecraft
RUN mkdir /root/require-files
RUN mkdir /tmp/minecraft
RUN mkdir /tmp/rcon
RUN pacman -Syyu jre-openjdk-headless jq bc --noconfirm

WORKDIR /tmp/minecraft
RUN curl -sLo minecraft.jar https://api.purpurmc.org/v2/purpur/$(curl -sL https://api.purpurmc.org/v2/purpur | jq -r .versions[-1])/latest/download && \
    echo "eula=true" > eula.txt && \
    java --add-modules=jdk.incubator.vector -Xmx$MEM -Xms$MEM -jar ./minecraft.jar nogui & \
    sleep 30 && \
    killall -9 java && \
    echo enable-rcon=true >> server.properties && \
    echo rcon.password=$RCONPASSWD >> server.properties && \
    echo rcon.port=25575 >> server.properties && \
    cp server.properties /root/require-files && \
    cp eula.txt /root/require-files && \
    rm -rf ./*

# rcon install
WORKDIR /tmp
RUN pacman -S pkgconf make gcc cmake check libbsd git --noconfirm && \
    git clone https://github.com/n0la/rcon.git && cd rcon && \
        mkdir build && cd /tmp/rcon/build && \
            cmake .. -DCMAKE_INSTALL_PREFIX=/usr && \
            make && \
            make install && \
        cd ../ && \
        pacman -Rs pkgconf make gcc cmake check libbsd git --noconfirm && \
        rm -rf ./*
RUN bash
COPY ./main.sh /root/

WORKDIR /root
RUN chmod +x ./main.sh

CMD ["bash", "-c", "./main.sh"]