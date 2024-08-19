FROM debian:bullseye@sha256:0bb606aad3307370c8b4502eff11fde298e5b7721e59a0da3ce9b30cb92045ed as builder

RUN apt-get update && \
    apt-get install --no-install-recommends -y cmake g++ build-essential libboost-program-options1.74-dev libpng++-dev zlib1g-dev

COPY . /bedrock-viz

WORKDIR /bedrock-viz

RUN ./buildscript.sh

FROM node:22.6.0-bullseye-slim@sha256:a4b9a4773f239be06956f24fdf0b371ef87da3ad2d3eb877669254da947fa8b2

RUN apt-get update && \
    apt-get install --no-install-recommends -y libboost-program-options1.74.0 libpng16-16 && \
    rm -rf /var/cache/apt

COPY --from=builder /usr/local/share/bedrock-viz /usr/local/share/bedrock-viz
COPY --from=builder /usr/local/bin/bedrock-viz /usr/local/bin/
COPY frontend.js ./

EXPOSE 3333

ENTRYPOINT ["node", "frontend.js"]
