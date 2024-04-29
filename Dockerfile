FROM debian:bullseye@sha256:f860cec7ccaf31b42cd60b6a409f9dad9510ea27fca9c2864741087b4298a1e3 as builder

RUN apt-get update && \
    apt-get install --no-install-recommends -y cmake g++ build-essential libboost-program-options1.74-dev libpng++-dev zlib1g-dev

COPY . /bedrock-viz

WORKDIR /bedrock-viz

RUN ./buildscript.sh

FROM node:22.0.0-bullseye-slim@sha256:e0110bf0d381c3dd1d3e9d14190f7a1940a861122fcb228c1473fa065f168529

RUN apt-get update && \
    apt-get install --no-install-recommends -y libboost-program-options1.74.0 libpng16-16 && \
    rm -rf /var/cache/apt

COPY --from=builder /usr/local/share/bedrock-viz /usr/local/share/bedrock-viz
COPY --from=builder /usr/local/bin/bedrock-viz /usr/local/bin/
COPY frontend.js ./

EXPOSE 3333

ENTRYPOINT ["node", "frontend.js"]
