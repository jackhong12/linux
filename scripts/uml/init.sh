#!/bin/sh

# initialize
ls > /dev/null 2>&1
if [ $? -ne 0 ]; then
    # busybox
    /bin/busybox --install

    # net
    /sbin/ip link set eth0 up
    /sbin/ip address add 192.168.100.101/24 dev eth0

    # modules
    mv /lib/modules/VER /lib/modules/`uname -r`
    depmod -ae `uname -r`
fi

export PS1='\[\033[01;32mUML:\w\033[00m \$ '

# fs
mount -t proc none /proc
mount -t sysfs sys /sys

exec /sbin/tini /bin/sh +m
