#!/usr/bin/bash
MOUNT=/tmp/mnt-fuse
mkdir $MOUNT
ls $MOUNT
vu_insmod vufuse
mount -t vufuseext2 -o rw+ ~/tests/linux.img $MOUNT
ls $MOUNT
vusu -c 'mount -t vufuseext4 file.iso /tmp/mnt1'
