#Creates a centos6 rpm build environment
FROM centos:centos6

MAINTAINER Ryan Bauman <ryanbauman@gmail.com>

#install epel and build env
RUN yum install -y http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
#RUN yum install -y sudo yum-utils git which wget @buildsys-build
RUN yum install -y createrepo rpmdevtools yum-utils git which wget @buildsys-build

ADD bashrc /root/.bashrc
ADD bash_profile /root/.bash_profile
ADD build.sh /root/build.sh
RUN chmod a+x /root/build.sh

#set up rpmbuild env
USER root
ENV HOME /root
RUN rpmdev-setuptree
RUN mkdir -p /root/yum

#Allow execution of bash commands
#ENTRYPOINT ["/bin/bash", "-l"]
ENTRYPOINT ["/root/build.sh"]

#configure environment
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV SHELL /bin/bash

#define and create an internal yum repo . . .
ADD container.repo /etc/yum.repos.d/
RUN cd /root/yum && createrepo .

VOLUME ["/root/yum"]
