FROM debian:bullseye@sha256:d584e02c85bc9b3bd8df01662e4f605a66e1b9a04f9dea0e288f56da474269a0 as builder

RUN apt-get update && \
    apt-get install --no-install-recommends -y cmake g++ build-essential libboost-program-options1.74-dev libpng++-dev zlib1g-dev

COPY . /bedrock-viz

WORKDIR /bedrock-viz

RUN ./buildscript.sh

FROM node:22.3.0-bullseye-slim@sha256:bdd4d07d0320466d0720f916d752b0fa31314d53c06caad6efe85956e59ab966

RUN apt-get update && \
    apt-get install --no-install-recommends -y libboost-program-options1.74.0 libpng16-16 && \
    rm -rf /var/cache/apt

COPY --from=builder /usr/local/share/bedrock-viz /usr/local/share/bedrock-viz
COPY --from=builder /usr/local/bin/bedrock-viz /usr/local/bin/
COPY frontend.js ./

EXPOSE 3333

ENTRYPOINT ["node", "frontend.js"]
