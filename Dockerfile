FROM archlinux:latest

ENV MEM=1G
ENV RCONPASSWD=minecraft

WORKDIR /root
RUN pacman -Syyu jre-openjdk-headless jq --noconfirm
RUN curl -sLo version https://api.purpurmc.org/v2/purpur
RUN curl -sLo minecraft.jar https://api.purpurmc.org/v2/purpur/$(cat version | jq -r .versions[-1])/latest/download
RUN mkdir /root/minecraft
RUN mv /root/minecraft.jar /root/minecraft

WORKDIR /root/minecraft
RUN echo "eula=true" > eula.txt
RUN bash -c "java --add-modules=jdk.incubator.vector -Xmx$MEM -Xms$MEM -jar minecraft.jar nogui & sleep 40 && killall -9 java"
RUN rm -rf world
RUN echo enable-rcon=true >> server.properties
RUN echo rcon.password=$RCONPASSWD >> server.properties
RUN echo rcon.port=25575 >> server.properties

# rcon install
RUN pacman -S pkgconf make gcc cmake check libbsd git --noconfirm && git clone https://github.com/n0la/rcon.git && \
    cd /root/minecraft/rcon && \
    mkdir build && \
    cd /root/minecraft/rcon/build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr && \
    make && \
    make install && \
    cd /root/minecraft && \
    pacman -Rs pkgconf make gcc cmake check libbsd git --noconfirm

COPY ./buckup.sh /root/

RUN chmod +x  /root/buckup.sh

CMD ["bash", "-c", "/root/buckup.sh & java --add-modules=jdk.incubator.vector -Xmx$MEM -Xms$MEM -jar minecraft.jar nogui"]