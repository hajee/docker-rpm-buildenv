docker run -i -t -rm -v $(pwd):/tmp -v $(pwd)/rpm:/root/rpm/RPMS hajee/rpmbuild /bin/sh
cd /tmp
sh build.sh
