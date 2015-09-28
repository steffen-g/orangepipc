#Kernel and U-Boot for Orange Pi PC with Allwinner H3 

If someone finds out why HDMI is not working, please let me know. --> HDMI is now working, but not with my HDMI DVI adapter and LCD screen.

###0. Prerequisites
arm-linux-gnueabihf- and arm-none-eabi- toolchain has to be installed.

###1. Building U-Boot
Building U-Boot from SDK with modification for reading a script.bin converted fex file:

```
./build.sh uboot-all /dev/sde
````

Where /dev/sde has to be replaced by your SD card.

###2. Edit fex file
```
./build.sh fex-edit
````

###3. Convert and copy fex file
```
./build.sh fex-copy /media/sd
````

Replace /media/sd by the mount point of your SD card.

###4. Building Kernel
```
./build.sh kernel-all /media/sd
````

Replace /media/sd by the mount point of your SD card.

