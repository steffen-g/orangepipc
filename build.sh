#!/bin/sh

cd brandy/u-boot-2011.09/
make clean
make -j4
cd ../../tools/pack/chips/sun8iw7p1/bin
cp ../../../../../brandy/u-boot-2011.09/u-boot.bin u-boot.fex
../../../../../sunxi-tools/fex2bin ../configs/dolphin-p1/sys_config.fex ../configs/dolphin-p1/out/fex/sys_config.bin 
../../../pctools/linux/mod_update/update_uboot u-boot.fex ../configs/dolphin-p1/out/fex/sys_config.bin

dd if=u-boot.fex of=/dev/sde bs=1k seek=16400
cp ../configs/dolphin-p1/out/fex/sys_config.bin $1

cd linux-3.4
#make orangepipc_defconfig
make uImage -j4
cp arch/arm/boot/uImage $1

