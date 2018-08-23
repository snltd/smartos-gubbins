#!/usr/bin/ksh

# Build a minimal Ruby with some gems

VERSION="2.5.1"
	# The version of Ruby to package

PREFIX="/opt/local/ruby"
	# Where the package will install, and what to call the final
	# package.  Change to suit your site. WARNING - THIS GETS NUKED!

DIR=$(mktemp -d)
	# Temporary directory

PKG_NAME="sysdef-ruby-${VERSION}.tgz"
	# Name of final package

PATH="/usr/bin:/usr/sbin:/opt/local/bin:/opt/local/sbin"
	# Always set your path

export CFLAGS="-O2"

cd $DIR

if [[ $1 != "nobuild" ]]
then
	SRCFILE="ruby-${VERSION}.tar.bz2"

	rm -fr $PREFIX

	wget --no-verbose \
		 --no-check-certificate \
		 "https://cache.ruby-lang.org/pub/ruby/${VERSION%.*}/$SRCFILE"

	rm -fr $VERSION
	tar zxf $SRCFILE
	cd ${SRCFILE%.tar*}

    gsed -i '13i#undef HAVE_SSLV2_METHOD' ext/openssl/ossl_ssl.c

	./configure \
		--with-opt-dir=/opt/local \
		--prefix=$PREFIX \
		--disable-install-doc \
		--enable-dtrace \
		--without-valgrind

	gmake -j4
	gmake test
	gmake install
fi

${PREFIX}/bin/gem install bundle --no-rdoc --no-ri

cat <<-EOGEMFILE >/tmp/Gemfile
source 'https://rubygems.org'
gem 'puppet', '~> 4.8.0'
gem 'ruby-shadow', '~> 2.5.0'
gem 'wavefront-cli'
gem 'sinatra'
gem 'kramdown'
gem 'rouge', '1.10.1'
gem 'puma'
gem 'slim'
EOGEMFILE

${PREFIX}/bin/bundle install --gemfile=/tmp/Gemfile

find ${PREFIX} -type f | sed "s|${PREFIX}/||" >${DIR}/pkglist

pkg_info -X pkg_install \
  | egrep '^(MACHINE_ARCH|OPSYS|OS_VERSION|PKGTOOLS_VERSION)' \
  >${DIR}/build-info

print "vanilla Ruby ${VERSION}" >${DIR}/comment

print "Ruby ${VERSION} with no dependencies. Includes gems: " \
	>${DIR}/description

grep ^gem /tmp/Gemfile | cut -d\' -f2 | tr "\n" " " \
	>>${DIR}/description

pkg_create \
	-B ${DIR}/build-info \
	-d ${DIR}/description \
	-c ${DIR}/comment \
	-f ${DIR}/pkglist \
	-I $PREFIX \
	-p $PREFIX \
	-U \
	${HOME}/${PKG_NAME}

cd
rm -fr $DIR
