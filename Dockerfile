# Start from latest alpine
FROM alpine
MAINTAINER Jake Skeates <jake@skeat.es>

ARG TIPPECANOE_RELEASE="1.30.1"

# Update repos and install dependencies
RUN apk update
RUN apk upgrade
RUN apk add git
RUN apk add bash build-base sqlite-libs sqlite-dev zlib-dev protobuf 

# Clone git
RUN mkdir -p /tmp/tippecanoe
RUN cd /tmp/tippecanoe && git clone https://github.com/mapbox/tippecanoe.git .
RUN cd /tmp/tippecanoe && git checkout tags/$TIPPECANOE_RELEASE 
RUN cd /tmp/tippecanoe && make -j && make install

# Remove temp dir
RUN rm -rf /tmp/tippecanoe

# Remove unneeded packages
RUN apk del build-base
RUN apk del git

# Setup working dir
RUN mkdir -p /home/tippecanoe

# Setup environment
WORKDIR /home/tippecanoe
ENTRYPOINT /bin/bash