#!/usr/bin/ksh -e

exec 1>/var/log/bootstrap.log
exec 2>&1

wget --no-check-certificate -P /var/tmp \
    https://us-east.manta.joyent.com/snltd/public/snltd-ruby-2.2.3.tgz \

wget --no-check-certificate -P /var/tmp \
    https://us-east.manta.joyent.com/snltd/public/snltd-git-2.6.2.tgz \

# We have to do some horrible hackery to install our homemade packages

PIC=/opt/local/etc/pkg_install.conf
PICB=/opt/local/etc/pkg_install.conf.backup

cp $PIC $PICB
sed 's/always$/trusted/' $PICB >$PIC

yes | /opt/local/sbin/pkg_add /var/tmp/snltd-ruby-2.2.3.tgz
yes | /opt/local/sbin/pkg_add /var/tmp/snltd-git-2.6.2.tgz
rm /var/tmp/snltd-ruby-2.2.3.tgz
rm /var/tmp/snltd-git-2.6.2.tgz

mv $PICB $PIC

crle -u -64 -l /opt/local/lib
for i in /opt/local/git/bin/* /opt/local/ruby/bin/*
do
	ln -s $i /opt/local/bin
done

/opt/local/bin/pkgin update
/opt/local/bin/pkgin -y in gmp

/opt/local/git/bin/git clone https://github.com/snltd/joyent-puppet.git \
    /opt/puppet

mkdir -p /etc/facter/facts.d
echo "environment=production\nrole=sinatra" >/etc/facter/facts.d/facts.txt

/opt/puppet/puppet-apply.sh
