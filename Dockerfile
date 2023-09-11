FROM debian:bullseye@sha256:f33900927c0a8bcf3f0e2281fd0237f4780cc6bc59729bb3a10e75b0703c5ca7 as builder

RUN apt-get update && \
    apt-get install --no-install-recommends -y cmake g++ build-essential libboost-program-options1.74-dev libpng++-dev zlib1g-dev

COPY . /bedrock-viz

WORKDIR /bedrock-viz

RUN patch -p0 < patches/leveldb-1.22.patch && \
    patch -p0 < patches/pugixml-disable-install.patch && \
    mkdir -p build

WORKDIR /bedrock-viz/build
RUN cmake .. && \
    make && \
    make install

FROM node:20.5.1-bullseye-slim@sha256:f54a16be368537403c6f20e6e9cfa400f4b71c71ae9e1e93558b33a08f109db6

RUN apt-get update && \
    apt-get install --no-install-recommends -y libboost-program-options1.74.0 libpng16-16 && \
    rm -rf /var/cache/apt

COPY --from=builder /usr/local/share/bedrock-viz /usr/local/share/bedrock-viz
COPY --from=builder /usr/local/bin/bedrock-viz /usr/local/bin/
COPY frontend.js ./

EXPOSE 3333

ENTRYPOINT ["node", "frontend.js"]
