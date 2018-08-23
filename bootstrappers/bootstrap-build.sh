#!/usr/bin/ksh -e

GIT_VER=2.6.2

exec 1>/var/log/bootstrap.log
exec 2>&1

wget -P /var/tmp http://manta.localnet/snltd-git-${GIT_VER}.tgz

# We have to do some horrible hackery to install our homemade packages

PIC=/opt/local/etc/pkg_install.conf
PICB=/opt/local/etc/pkg_install.conf.backup

cp $PIC $PICB
sed 's/always$/trusted/' $PICB >$PIC

yes | /opt/local/sbin/pkg_add /var/tmp/snltd-git-${GIT_VER}.tgz
rm /var/tmp/snltd-git-${GIT_VER}.tgz

mv $PICB $PIC

crle -u -64 -l /opt/local/lib

for i in /opt/local/git/bin/*
do
	ln -s $i /opt/local/bin
done

/opt/local/bin/pkgin update
/opt/local/bin/pkgin -y in cfengine-3.7.3
