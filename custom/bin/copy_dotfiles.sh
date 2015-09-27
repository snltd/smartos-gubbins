#!/usr/bin/ksh

ls /opt/custom/config | while read f 
do
	cp /opt/custom/config/$f /root/.$f
done
