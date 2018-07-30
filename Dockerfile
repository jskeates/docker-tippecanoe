# Start from latest alpine
FROM alpine:3.8
MAINTAINER Jake Skeates <jake@skeat.es>

ARG TIPPECANOE_RELEASE="1.30.1"

# Update repos and install dependencies
RUN apk update && apk upgrade \
    && apk add git \
    && apk add bash build-base sqlite-libs sqlite-dev zlib-dev protobuf 

# Clone git
RUN mkdir -p /tmp/tippecanoe \
    && cd /tmp/tippecanoe && git clone https://github.com/mapbox/tippecanoe.git . \
    && cd /tmp/tippecanoe && git checkout tags/$TIPPECANOE_RELEASE \
    && cd /tmp/tippecanoe && make -j && make install

# Remove temp dir and remove unneeded packages
RUN rm -rf /tmp/tippecanoe \
    && apk del build-base \
    && apk del git

# Setup working dir
RUN mkdir -p /home/tippecanoe

# Setup environment
WORKDIR /home/tippecanoe
ENTRYPOINT /bin/bash