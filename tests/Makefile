obj-m += hello.o

PWD := $(shell pwd)
KDIR := $(PWD)/..

default:
	$(MAKE) -C $(KDIR) M=$(PWD) modules ARCH=um

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean ARCH=um
