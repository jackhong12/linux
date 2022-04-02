#!/bin/sh
./linux umid=uml0 \
        root=/dev/root rootfstype=hostfs hostfs=./rootfs \
        hostname=uml1 eth0=tuntap,tap0 \
        rw mem=64M init=/init.sh quiet

stty sane ; echo
