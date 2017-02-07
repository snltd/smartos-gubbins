#!/usr/bin/ksh -e

#=============================================================================
#
# build_git.sh
# -------------
#
# The SmartOS pkgin Ruby-2.2.2 pulls in Tk as a dependency, which drags
# in a load of X stuff. I don't want that. But I do want a bunch of
# native-extension gems. So, I decided to take the Omnibus style route,
# and build myself a clean Ruby with all the gems my application needs.
# I then package it all up. Finally, it gets uploaded to Manta.
#
# The package installs into /opt/local/ruby.
#
# Requires:
#   A native SmartOS zone with the following packages:
#     - gcc
#     - gmake
#     - mysql-client-5.6.25nb2 if you build the mysql2 gem, which I do
#
#  The 'manta' npm, if you wish to upload to Manta. You'll also need to
#  configure your keys and whatnot as per usual.
#
# If you don't want to compile Ruby from scratch (i.e. you just want to
# add gems into an existing install), use 'nobuild' as the sole
# argument.
#
# Caveats:
# The script is very quick and dirty. It was written in a hurry to get
# a job done. This comment block took longer than the code. The version
# of Ruby is a variable in the script. If you want to make it better,
# please do.
#
#  autoconf might not be able to find libgmp. You can fix this by
#  running `# crle -64 -u -l /opt/local/lib`.
#
# Some gems might need other packages. You'll work it out.
#
# R Fisher 09/2015
#
#=============================================================================

#-----------------------------------------------------------------------------
# VARIABLES

RVER="2.6.2"
	# The version of Ruby to package

PREFIX="/opt/local/git"
	# Where the package will install

PKG_NAME="snltd-git-${RVER}.tgz"
	# What to call the final package. Change to suit your site.

DIR=$(mktemp -d)
	# Temporary directory

PATH="/usr/bin:/usr/sbin:/opt/local/bin:/opt/local/sbin"
	# Always set your path

#-----------------------------------------------------------------------------
# SCRIPT STARTS HERE

if [[ $1 != "nobuild" ]]
then
	RFILE="git-${RVER}.tar.gz"

	rm -fr $PREFIX

	if ! test -f $RFILE
	then
		wget --no-verbose \
			 --no-check-certificate \
			 "https://www.kernel.org/pub/software/scm/git/$RFILE"
	fi

	rm -fr $RVER
	tar zxf $RFILE
	cd ${RFILE%.tar*}

	CFLAGS="-I/opt/local/include" LDFLAGS="-L/opt/local/lib" ./configure \
		--prefix=/opt/local/git \
		--with-curl \
		--with-openssl   \
		--without-tcltk
	gmake -j4
	gmake test
	gmake install
fi

find ${PREFIX} -type f | sed "s|${PREFIX}/||" >${DIR}/pkglist

pkg_info -X pkg_install \
  | egrep '^(MACHINE_ARCH|OPSYS|OS_VERSION|PKGTOOLS_VERSION)' \
  >${DIR}/build-info

print "minimal Git ${RVER}" >${DIR}/comment
print "Git ${RVER} with no dependencies." >${DIR}/description

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

if which mput >/dev/null 2>&1
then
	mput -f "${HOME}/${PKG_NAME}" "/$MANTA_USER/public"
fi
