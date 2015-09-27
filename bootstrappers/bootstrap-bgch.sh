#!/usr/bin/ksh

exec 1>/var/tmp/bootstrap.log
exec 2>&1

apt-get update
apt-get install -y software-properties-common apt-transport-https nfs-client

mkdir -p /usr/lib/bgch-puppet /usr/lib/bgch/bootstrap

mount -o sec=sys 192.168.1.2:/export/home/rob/work/bgch/puppet-ops \
	/usr/lib/bgch-puppet
mount -o sec=sys 192.168.1.2:/export/home/rob/work/bgch/bgch-bootstrap \
	/usr/lib/bgch/bootstrap
