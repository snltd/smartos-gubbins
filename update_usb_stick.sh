#!/usr/bin/ksh

REMOTE_IMG=https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/smartos-latest-USB.img.bz2 

LOCAL_IMG="${HOME}/smartos-latest-USB.img"

die()
{
	print -u2 "ERROR: $1"
	exit ${2:-1}
}

[[ $USER == root ]] && user=$SUDO_USER || user=$USER

df -h | grep "/media/$user" | read USB_DEV j1 j2 j3 j4 MPT

[[ -z $MPT ]] && die "can't find USB stick"

USB_DEV=${USB_DEV%%[0-9]}
print "Image will be written to ${USB_DEV}"

print "Fetching image"
curl -q $REMOTE_IMG | bzip2 -dc >$LOCAL_IMG || die "could not fetch image"

print "Unmounting USB device"
umount $MPT || die "could not unmount USB device"

print "Writing image to USB device"
dd if=${LOCAL_IMG} of=${USB_DEV} bs=1M >/dev/null 2>&1 || \
	die "could not write image to USB device"

print "Done"
