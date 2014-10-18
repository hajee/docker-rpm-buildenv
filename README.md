# docker rpm-buildenv
Creates a [Docker](https://www.docker.com/) image useful for building RPMs

The image can be pulled from the [Docker Hub Registry](https://registry.hub.docker.com/u/ryanbauman/rpm-buildenv/)

This image runs a shell script that expects the docker workdir to be set to a location containing the source to build (including the specfile) and the specfile location within that location to be passed as an argument, e.g.:

    docker run --volume $PWD:/tmp --workdir /tmp ryanbauman/rpm-buildenv /root/build.sh /tmp/spec.spec

Optionally you may choose to create a yum repository that down stream images may consume via:

    docker run --volume $PWD:/tmp --volume <some location on disk>/yumrepo:/root/yum /data/jenkins/centos7/yumrepo:/root/yum --workdir /tmp ryanbauman/rpm-buildenv /root/build.sh /tmp/spec.spec

Or if you do not want to use the yum repository the image will install the built RPMs as a final step allowing you to tag and commit the finished container to reuse downstream.

