# Start from latest alpine
FROM alpine:3.8
MAINTAINER Jake Skeates <jake@skeat.es>

ARG TIPPECANOE_RELEASE="1.30.1"

# Update repos and install dependencies
RUN apk update \
    && apk upgrade \
    && apk add git bash build-base sqlite-libs sqlite-dev zlib-dev protobuf \
    && mkdir -p /tmp/tippecanoe \
    && cd /tmp/tippecanoe \
    && git clone https://github.com/mapbox/tippecanoe.git . \
    && cd /tmp/tippecanoe \
    && git checkout tags/$TIPPECANOE_RELEASE \
    && cd /tmp/tippecanoe \
    && make -j && make install \
    && rm -rf /tmp/tippecanoe \
    && apk del build-base \
    && apk del git \
    && mkdir -p /home/tippecanoe

# Setup environment
WORKDIR /home/tippecanoe
ENTRYPOINT /bin/bash