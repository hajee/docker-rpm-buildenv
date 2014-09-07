#!/bin/bash
#for now, assume relative path to specfile is provided as argument
#and the sources are the working directory of the container

#source and display the build environment
. ~/.bashrc
printenv

#Run spectool on the specfile; grab the source tarball name
sourcefile=`spectool $1 |awk -F" " '{print $2}'`
echo $sourcefile

#Strip the extensions to obtain the directory name
directory=`basename $sourcefile .tar.gz`
echo $directory
echo $PWD

#copy the sources to the sources dir
cp -r * /root/rpmbuild/SOURCES 

#copy the specfile to the specs dir
cp $1 /root/rpmbuild/SPECS

#create the source tarball
cd /root/rpmbuild/SOURCES
tar zcf $sourcefile --transform "s|^|$directory/|" *

#install the build dependencies according to the specfile
yum-builddep -y $1
#build source/binary rpms
rpmbuild -ba /root/rpmbuild/SPECS/*.spec

#copy binary rpms to volume
find /root/rpmbuild/RPMS -type f -exec cp {} /root/yum \;

#createrepo useful? anyway, install the binary RPMs so others may consume this environment
cd /root/yum
createrepo .
yum install -y *.rpm

#clean rpmbuild env
find /root/rpmbuild -type f -exec rm {}  \;
