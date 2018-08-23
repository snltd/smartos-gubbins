#!/bin/ksh -e

# Build from source, and package for SmartOS, a modified version
# of CfEngine.
#
# TODO SMF stuff


BUILD_DIR=/tmp/build-cfengine
PREFIX=/var/cfengine
CURL=curl-7.59.0
CFENGINE_VER=3.10.4
CFENGINE=cfengine-$CFENGINE_VER
MASTERFILES=cfengine-masterfiles-${CFENGINE_VER}.pkg.tar.gz

[[ -d $BUILD_DIR ]] && rm -fr $BUILD_DIR
mkdir $BUILD_DIR

rm -fr $PREFIX
       # $CFENGINE.tar.gz $CURL.tar.bz2 $MASTERFILES \
	   # $CFENGINE $CURL cfengine-smartos-metadata

cd $BUILD_DIR

wget -q --no-check-certificate https://curl.haxx.se/download/${CURL}.tar.bz2
tar jxf ${CURL}.tar.bz2
cd $CURL
./configure --prefix=$PREFIX --disable-ldap --disable-manual
gmake -j4
gmake install

cd $BUILD_DIR

wget -q --no-check-certificate \
  https://cfengine-package-repos.s3.amazonaws.com/tarballs/$CFENGINE.tar.gz
tar zxf ${CFENGINE}.tar.gz
cd $CFENGINE
./configure --without-mysql --without-postgresql
gmake -j4
gmake install

cd $BUILD_DIR

wget -q --no-check-certificate \
  https://cfengine-package-repos.s3.amazonaws.com/community_binaries/Community-${CFENGINE_VER}/misc/${MASTERFILES}
gtar xvf ${BUILD_DIR}/$MASTERFILES -C /var/cfengine

cd $BUILD_DIR

git clone https://github.com/bahamat/cfengine-smartos-metadata.git
cd cfengine-smartos-metadata
gmake

cd /var

tar zcf ${HOME}/${CFENGINE}-smartos.tar.gz cfengine
