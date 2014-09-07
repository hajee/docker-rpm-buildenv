# docker rpm-buildenv
Creates a [Docker](https://www.docker.com/) image useful for building RPMs

The image can be pulled from the [Docker Hub Registry](https://registry.hub.docker.com/u/ryanbauman/rpm-buildenv/)

The default entrypoint for this image runs a shell script that expects the docker workdir to be set to a location containing the source to built (including the specfile) and the specfile location within that location to be passed as an argument, e.g.:

    docker run --volume $PWD:/tmp --workdir /tmp ryanbauman/rpm-buildenv /tmp/spec.spec

The shell script packaged with this image builds and installs the binary RPMs and then cleans the build environment so that dependent builds may consume the resultant environment.

Currently only a CentOS 6 environment is provided.  CentOS 5 and CentOS 7 environments will be supported in the future.
