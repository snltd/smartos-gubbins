#!/usr/bin/ksh
#
#=============================================================================
#
# rebuild.sh
# ----------
#
# A script to tear down and rebuild a VM (or multiple VMs) using the
# alias. Set SPEC_DIR to wherever you keep the JSON files which
# describe your VMs.
#
# R Fisher 08/2015
#
#=============================================================================

SPEC_DIR="/var/tmp"
PATH=/usr/bin:/usr/sbin

if [[ $# == 0 ]]
then
	print -u2 "ERROR: no vm alias(es)"
	exit 1
fi

for vm in $*
do
	spec_file=$(grep -l "alias\":.*\"${vm}\"" $SPEC_DIR/*.js)

	if [[ -z $spec_file ]]
	then
		print -u2 "ERROR: can't find spec file for ${vm}"
		continue
	fi

	vmadm list | grep "${vm}$" | read uuid junk

	if [[ -z $uuid ]]
	then
		print -u2 "ERROR: can't find ${vm} VM"
		continue
	fi

	print "destroying $vm"
	vmadm destroy $uuid
	print "creating $vm"
	vmadm create -f $spec_file | cut -d\  -f4
done

