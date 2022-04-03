#!/bin/bash

# install dependencies
sudo apt install build-essential libncurses-dev flex bison xz-utils wget ca-certificates bc -y

# build UML
make mrproper
make defconfig ARCH=um SUBARCH=x86_64
make linux ARCH=um SUBARCH=x86_64 -j `nproc`

# rootfs
sudo apt install fakeroot -y
export REPO=http://dl-cdn.alpinelinux.org/alpine/v3.13/main
mkdir -p rootfs
curl $REPO/x86_64/APKINDEX.tar.gz | tar -xz -C /tmp/
export APK_TOOL=`grep -A1 apk-tools-static /tmp/APKINDEX | cut -c3- | xargs printf "%s-%s.apk"`
curl $REPO/x86_64/$APK_TOOL | fakeroot tar -xz -C rootfs
fakeroot rootfs/sbin/apk.static \
    --repository $REPO --update-cache \
    --allow-untrusted \
    --root $PWD/rootfs --initdb add alpine-base
echo $REPO > rootfs/etc/apk/repositories
echo "LABEL=ALPINE_ROOT / auto defaults 1 1" >> rootfs/etc/fstab

# init.sh
cp scripts/uml/init.sh ./rootfs/init.sh
chmod +x rootfs/init.sh

# tini
wget -O rootfs/sbin/tini https://github.com/krallin/tini/releases/download/v0.19.0/tini-static
chmod +x rootfs/sbin/tini

# net
sudo ip tuntap add tap0 mode tap
sudo ip link set tap0 up
sudo ip address add 192.168.100.100/24 dev tap0

# modules
make ARCH=um SUBARCH=x86_64 modules
make _modinst_ MODLIB=`pwd`/rootfs/lib/modules/VER ARCH=um

# gdbinit
cp ./scripts/uml/gdbinit ./
sed -i 's|FULLPATH|'"$PWD"'|' gdbinit

# kernel modules
# tests
make -C tests
cp tests/hello.ko rootfs/
# ticks
pushd tests/ticks
make
popd
cp tests/ticks/ticks.ko rootfs/

# script to run UML
cp ./scripts/uml/UML.sh ./
chmod +x UML.sh
