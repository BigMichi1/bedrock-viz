FROM debian:bullseye@sha256:7aef2e7d061743fdb57973dac3ddbceb0b0912746ca7e0ee7535016c38286561 as builder

RUN apt-get update && \
    apt-get install --no-install-recommends -y cmake g++ build-essential libboost-program-options1.74-dev libpng++-dev zlib1g-dev

COPY . /bedrock-viz

WORKDIR /bedrock-viz

RUN ./buildscript.sh

FROM node:22.5.1-bullseye-slim@sha256:1381d1559eccfba1fd8ed9a0a47dddbb3602a185582783e1c049b8267530a5e4

RUN apt-get update && \
    apt-get install --no-install-recommends -y libboost-program-options1.74.0 libpng16-16 && \
    rm -rf /var/cache/apt

COPY --from=builder /usr/local/share/bedrock-viz /usr/local/share/bedrock-viz
COPY --from=builder /usr/local/bin/bedrock-viz /usr/local/bin/
COPY frontend.js ./

EXPOSE 3333

ENTRYPOINT ["node", "frontend.js"]
