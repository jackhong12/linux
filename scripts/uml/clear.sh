#!/bin/bash

rm -rf rootfs

sudo ip tuntap del dev tap0 mod tap

rm UML.sh

# gdb
rm gdbinit
