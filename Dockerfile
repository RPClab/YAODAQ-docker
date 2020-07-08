FROM alpine:latest

RUN apk add --no-cache gcc g++ musl-dev cmake make git libstdc++ linux-headers ca-certificates &&\
    git clone https://github.com/RPClab/YAODAQ.git &&\
    cmake -S YAODAQ -B ./build -DENABLE_EXTRAS=OFF -DBUILD_DAQ=OFF -DBUILD_WEBSERVER=OFF -DBUILD_ANALYSIS=OFF -DENABLE_TESTS=OFF -DBUILD_DUMP=OFF -DBUILD_LOGGER=OFF -DBUILD_CONTROLLER=OFF -DENABLE_DOCS=OFF -DBUILD_WEBSOCKETSERVER=ON -DBUILD_CONFIGURATOR=OFF -DBUILD_OLD_WAVEDUMP=OFF -DBUILD_CAEN=OFF -DCMAKE_INSTALL_PREFIX="" -DBUILD_WebServer=OFF &&\
    cmake --build  ./build &&\
    cmake --install ./build &&\
    apk del --no-cache gcc g++ cmake make git linux-headers &&\
    rm -rf YAODAQ /root/.conan /root/.local /lib64 /include build  &&\
    chmod +x /bin/WebSocketServer &&\
    ldd /bin/WebSocketServer
RUN du -sch
ENTRYPOINT ["WebSocketServer"]
