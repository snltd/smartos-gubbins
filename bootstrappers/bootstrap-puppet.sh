#!/usr/bin/ksh -e

exec 1>/var/log/bootstrap.log
exec 2>&1

echo '%sysadmin ALL=(ALL) NOPASSWD: ALL' >>/opt/local/etc/sudoers
echo "set -o vi" >> /root/.profile

wget -q --no-check-certificate -P /var/tmp \
	https://us-east.manta.joyent.com/snltd/public/snltd-ruby-2.2.3.tgz \

yes | /opt/local/sbin/pkg_add /var/tmp/snltd-ruby-2.2.3.tgz
rm /var/tmp/snltd-ruby-2.2.3.tgz

#mkdir /mnt
#mount 192.168.1.2:/export/home/rob/work/joyent-puppet /mnt
#/mnt/puppet-apply.sh

/opt/local/bin/pkgin update
/opt/local/bin/pkgin -y in git-base gmp

/opt/local/bin/git clone https://github.com/snltd/joyent-puppet.git \
	/opt/puppet

mkdir -p /etc/facter/facts.d
echo "environment=production\nrole=sinatra" >/etc/facter/facts.d/facts.txt

/opt/puppet/puppet-apply.sh
