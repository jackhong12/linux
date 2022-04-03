obj-m := ticks.o

KDIR= ../../

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules ARCH=um
clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean ARCH=um
