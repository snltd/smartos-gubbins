#!/usr/bin/ksh

# Configure a new SmartOS build

if (( $# == 0 ))
then
	print -u2 "usage: ${0##*/} [HOST]..."
	exit 1
fi

DIR=$(mktemp -d)
INC=${DIR}/config.inc

mkdir $INC

if test -f ${HOME}/.ssh/id_rsa.pub
then
	cp ${HOME}/.ssh/id_rsa.pub ${INC}/authorized_keys
fi

CONFIG="
root_authorized_keys_file=authorized_keys
default_keymap=uk
"

for host in $*
do
	print "copying to $host"
	scp -rp $INC root@${host}:/usbkey/config.inc
	echo "$CONFIG" | ssh root@$host "cat - >>/usbkey/config"
done
