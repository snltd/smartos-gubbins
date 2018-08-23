#!/usr/bin/ksh -e

VERSION="2.15.0"
	# Required version
PREFIX="/opt/local/git"
	# Where the package will install. Watch out, this gets nuked!
PKG_NAME="sysdef-git-${VERSION}.tgz"
	# What to call the final package. Change to suit your site.
DIR=$(mktemp -d)
	# Temporary directory
PATH="/usr/bin:/usr/sbin:/opt/local/bin:/opt/local/sbin"
	# Always set your path

export INSTALL=ginstall

mkdir -p $DIR

cd $DIR

if [[ $1 != "nobuild" ]]
then
	SRCFILE="git-${VERSION}.tar.gz"

	rm -fr $PREFIX

	if ! test -f $SRCFILE
	then
		wget --no-verbose \
			 --no-check-certificate \
			 "https://www.kernel.org/pub/software/scm/git/$SRCFILE"
	fi

	rm -fr $VERSION
	tar zxf $SRCFILE
	cd ${SRCFILE%.tar*}
	gsed -i 's|/usr/ucb/install|/opt/local/bin/install|' config.mak.uname

	CFLAGS="-I/opt/local/include" LDFLAGS="-L/opt/local/lib" \
		./configure \
			--prefix=/opt/local/git \
			--with-curl \
			--with-openssl   \
			--without-tcltk
	gmake -j4
	#gmake test
	gmake install
fi

find ${PREFIX} -type f | sed "s|${PREFIX}/||" >${DIR}/pkglist

pkg_info -X pkg_install \
  | egrep '^(MACHINE_ARCH|OPSYS|OS_VERSION|PKGTOOLS_VERSION)' \
  >${DIR}/build-info

print "minimal Git ${VERSION}" >${DIR}/comment
print "Git ${VERSION} with no dependencies." >${DIR}/description

pkg_create \
	-B ${DIR}/build-info \
	-d ${DIR}/description \
	-c ${DIR}/comment \
	-f ${DIR}/pkglist \
	-I $PREFIX \
	-p $PREFIX \
	-P curl \
	-U \
	${HOME}/${PKG_NAME}

rm -fr $DIR
