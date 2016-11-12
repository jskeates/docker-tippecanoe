# Dockerized Tippecanoe
This is a Docker image for [Mapbox's Tippecanoe](https://github.com/mapbox/tippecanoe), based on Alpine Linux.

The currently built version at the `latest` tag is `1.14.4`.

- **Small**: just 21.5MB total
- **Safe**: run as an unprivileged, non-root user
- **Flexible**: elevate to root with `sudo` to install more packages

## Usage
Run with `docker run`, mounting a local directory or use Docker volumes as needed wth `-v`. See below for specific examples.
By default, processes will be run with the `tippecanoe` user in its home directory: `/home/tippecanoe`.

### Interactive Mode with `bash`
Bash comes preinstalled and will run as the default entrypoint.
```shell
docker run -it -v $HOME/tippecanoe:/home/tippecanoe jskeates/tippecanoe:latest
bash-4.3$ tippecanoe -h
tippecanoe: unrecognized option: h
Usage: tippecanoe --output=output.mbtiles [--name=...] [--layer=...]
...
```

### Non-interactive: Directly Invoke Tippecanoe
Alternatively, you can run `tippecanoe` directly.
This is more useful in a script running on the host.
```shell
docker run -it -v $HOME/tippecanoe:/home/tippecanoe jskeates/tippecanoe:latest tippecanoe -o output.mbtiles input.geojson
```

### Disable `sudo`
For additional safety (for example, running in a production, scripted process),
you can disable accessing the `root` user via `sudo`.

You can achieve this by mounting `/dev/null` to `/etc/sudoers` inside the container.
```shell
docker run -it -v $HOME/tippecanoe:/home/tippecanoe -v /dev/null:/etc/sudoers jskeates/tippecanoe:latest
bash-4.3$ sudo apk update
sudo: /etc/sudoers is not a regular file
sudo: no valid sudoers sources found, quitting
sudo: unable to initialize policy plugin
```

## Building A Different Version
To build a different version of Tippecanoe, set the `TIPPECANOE_RELEASE` build-arg
when building the image:
```shell
docker build --build-arg TIPPECANOE_RELEASE=1.14.0 .
```

Note that different versions may have different dependency requirements, so the build may fail,
or the build output may be broken.