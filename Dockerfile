FROM archlinux
ENV TZ Asia/Shanghai
# Make port 8888 available to the world outside this container
EXPOSE 8888
RUN pacman-db-upgrade
RUN pacman -Syyu --noconfirm
RUN pacman -Sy --noconfirm gcc cmake make git iproute2
#RUN  --no-cache add git musl-dev tzdata alpine-conf gcc make cmake g++ libc-dev zlib-dev zlib openssl-dev grep openssl libstdc++
RUN ip a show eth0 | grep -Po 'inet \K[\d.]+' > ./result &&\
    git clone https://github.com/RPClab/YAODAQ.git --recursive && \
    cd YAODAQ && \
    mkdir build &&\
    cd build &&\
    cmake -DBUILD_OLD_WAVEDUMP=OFF -DENABLE_TESTS=OFF -DENABLE_DOCS=OFF -DBUILD_ANALYSIS=OFF -DBUILD_WEBSERVER=OFF -DBUILD_CONFIGURATOR=OFF -DBUILD_CONTROLLER=OFF -DCAEN_HARDWARE=ON -DBUILD_DAQ=OFF -DCMAKE_INSTALL_PREFIX=/yaodaq .. &&\
    make -j20 && \
    make install -j20 && \
    cp -r -f /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" >  /etc/timezone && \
    pacman -Rscn --noconfirm gcc cmake make git iproute2 && \ 
    pacman -Scc --noconfirm && \ 
    cd ../../ &&\
    rm -rf ./YAODAQ 
ENTRYPOINT [ "sh", "-c", "/yaodaq/WebSocketServer -i $(cat ./result) -p 8888 -m 1024"]
