#Creates a centos6 rpm build environment
FROM centos:centos5

MAINTAINER Bert Hajee <hajee@moretIA.com>

#install epel and build env
RUN yum install -y epel-release
RUN yum install -y createrepo rpmdevtools yum-utils git which wget @buildsys-build

#set up rpmbuild env
USER root
ENV HOME /root
RUN rpmdev-setuptree; mv ~/rpmbuild ~/rpm
ADD .rpmmacros /root/.rpmmacros

#configure environment
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV SHELL /bin/bash
CMD  cd tmp; ./build.sh
