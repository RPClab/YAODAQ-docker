FROM alpine:latest

EXPOSE 80

RUN apk add --no-cache gcc g++ musl-dev cmake make git python3 libstdc++ perl linux-headers ca-certificates

RUN git clone https://github.com/RPClab/YAODAQ.git

RUN cmake -S YAODAQ -B ./build -DBUILD_WEBSERVER=OFF -DBUILD_ANALYSIS=OFF -DENABLE_TESTS=OFF -DBUILD_DUMP=OFF -DBUILD_LOGGER=OFF -DBUILD_CONTROLLER=OFF -DENABLE_DOCS=OFF -DBUILD_WEBSOCKETSERVER=ON -DBUILD_CONFIGURATOR=OFF -DBUILD_OLD_WAVEDUMP=OFF -DBUILD_CAEN=OFF -DCMAKE_INSTALL_PREFIX="" -DBUILD_WebServer=OFF

RUN cmake --build  ./build

RUN cmake --install ./build

RUN apk del gcc g++ cmake make git python3 perl

RUN chmod +x /bin/WebSocketServer && \
    ldd /bin/WebSocketServer
    
RUN rm -rf YAODAQ /root/.conan /lib64 /include

ENTRYPOINT ["WebSocketServer","-p 80","-m 1024"]
