FROM debian:bullseye@sha256:71cb300d5448af821aedfe63afd55ba05f45a6a79f00dcd131b96b780bb99fe4 as builder

RUN apt-get update && \
    apt-get install --no-install-recommends -y cmake g++ build-essential libboost-program-options1.74-dev libpng++-dev zlib1g-dev

COPY . /bedrock-viz

WORKDIR /bedrock-viz

RUN ./buildscript.sh

FROM node:21.6.0-bullseye-slim@sha256:ef46f8bf489e6a6c2d056e0c0bec23a4120b34aabb9551a446baf68282defa01

RUN apt-get update && \
    apt-get install --no-install-recommends -y libboost-program-options1.74.0 libpng16-16 && \
    rm -rf /var/cache/apt

COPY --from=builder /usr/local/share/bedrock-viz /usr/local/share/bedrock-viz
COPY --from=builder /usr/local/bin/bedrock-viz /usr/local/bin/
COPY frontend.js ./

EXPOSE 3333

ENTRYPOINT ["node", "frontend.js"]
