#!/bin/bash
#for now, assume relative path to specfile is provided as argument
#and the sources are the working directory of the container

function test {
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo "error with $1" >&2
        exit $status
    fi
    return $status
}

#source and display the build environment
. ~/.bashrc
printenv
set -x

# If the user has mounted the yum repo, we may need to recreate the repo
pushd /root/yum 
createrepo .
popd

#Run spectool on the specfile; grab the source tarball name
sourcefile=`spectool $1 |awk -F" " '{print $2}' | head -1`

#Strip the extensions to obtain the directory name: http://stackoverflow.com/questions/14703318/bash-script-remove-extension-from-file-name
directory=`basename $sourcefile | sed -r 's/\.[[:alnum:]]+\.[[:alnum:]]+$//'`
echo $directory
workdir=$PWD
echo $workdir

#copy the sources to the sources dir
cp -r * /root/rpmbuild/SOURCES 

#copy the specfile to the specs dir
cp $1 /root/rpmbuild/SPECS

#create the source tarball
#cd /root/rpmbuild/SOURCES
#test tar zcf $directory.tar.gz *

#install the build dependencies according to the specfile
test yum-builddep -y $1

#build source/binary rpms
test rpmbuild -ba /root/rpmbuild/SPECS/*.spec

#copy binary rpms to volume
find /root/rpmbuild/RPMS -type f -exec cp {} /root/yum \;

#createrepo useful? anyway, install the binary RPMs so others may consume this environment
#cd /root/yum
#createrepo .
#test yum install -y *.rpm

#clean rpmbuild env
find /root/rpmbuild -type f -exec rm {}  \;

# copy all the rpms into the workdir so they can be grabbed
cp /root/yum/*.rpm $workdir
chmod -R a+w /root/yum

set +x
