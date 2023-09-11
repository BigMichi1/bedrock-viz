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

FROM node:20.6.0-bullseye-slim@sha256:b905764e7025655563028e985a8c5a88023e181645d28e2fc7cf73e32293dfda

RUN apt-get update && \
    apt-get install --no-install-recommends -y libboost-program-options1.74.0 libpng16-16 && \
    rm -rf /var/cache/apt

COPY --from=builder /usr/local/share/bedrock-viz /usr/local/share/bedrock-viz
COPY --from=builder /usr/local/bin/bedrock-viz /usr/local/bin/
COPY frontend.js ./

EXPOSE 3333

ENTRYPOINT ["node", "frontend.js"]
