#!/bin/bash
# This scripts builds kernel and uboot as well as fex file for Allwinner 
# H3 as used for Orange Pi PC.
# Steffen Graf S.Graf@gsg-elektronik.de


function uboot-prepare {
	cd brandy/u-boot-2011.09/
	make mrproper
	make sun8iw7p1_config
	cd ../../
}

function uboot-build {
	cd brandy/u-boot-2011.09/
	make -j4
	cd ../../
}

function uboot-copy {
	cd tools/pack/chips/sun8iw7p1/bin
	cp ../../../../../brandy/u-boot-2011.09/u-boot.bin u-boot.fex
	../../../../../sunxi-tools/fex2bin ../configs/dolphin-p1/sys_config.fex ../configs/dolphin-p1/out/fex/sys_config.bin 
	../../../pctools/linux/mod_update/update_uboot u-boot.fex ../configs/dolphin-p1/out/fex/sys_config.bin
	#dd if=u-boot.fex of=$1 bs=1k seek=16400
	echo "U-Boot copied to $1"
}

function fex_gen {
	cd tools/pack/chips/sun8iw7p1/bin
	../../../../../sunxi-tools/fex2bin ../configs/dolphin-p1/sys_config.fex ../configs/dolphin-p1/out/fex/sys_config.bin
	cp ../configs/dolphin-p1/out/fex/sys_config.bin $1/script.bin
	echo "Copied to" $1/script.bin
}

function kernel_prepare {
	cd linux-3.4/
	make orangepipc_defconfig
	cd ../
}

function kernel_menu {
	cd linux-3.4/
	make menuconfig
	cd ../
}

function kernel_build {
	cd linux-3.4/
	make uImage -j4
	cd ../
}

function kernel_copy {
	cd linux-3.4/
	cp arch/arm/boot/uImage $1
	echo "Copied to" $1/uImage
}

case "$1" in
	"uboot-prepare")
		uboot-prepare
		;;
		
	"uboot-build")
		uboot-build
		;;
	
	"uboot-copy")
		if [ -z ${2+x} ]; 
			then echo "specify sd card e.g. /dev/sde"; 
			else uboot-copy $2; 
		fi
		;;
		
	"uboot-all")
		if [ -z ${2+x} ]; 
			then echo "specify sd card e.g. /dev/sde"; 
			else 
			uboot-prepare
			uboot-build
			uboot-copy $2; 
		fi
		;;
		
	"fex-copy")
		if [ -z ${2+x} ]; 
			then echo "specify path to mounted sdcard e.g. /media/sd"; 
			else fex_gen $2; 
		fi
		;;
		
	"fex-edit")
		editor tools/pack/chips/sun8iw7p1/configs/dolphin-p1/sys_config.fex
		;;
		
	"kernel-prepare")
		kernel_prepare
		;;
		
	"kernel-menu")
		kernel_menu
		;;
		
	"kernel-build")
		kernel_build
		;;
		
	"kernel-copy")
		if [ -z ${2+x} ]; 
			then echo "specify path to mounted sdcard e.g. /media/sd"; 
			else kernel_copy $2; 
		fi
		;;
		
	"kernel-all")
		kernel_prepare
		kernel_build
		kernel_copy
		;;
	
	*)
		echo "uboot-prepare"
		echo "uboot-build"
		echo "uboot-copy"
		echo "uboot-all"
		echo "fex-copy"
		echo "fex-edit"
		echo "kernel-prepare"
		echo "kernel-menu"
		echo "kernel-build"
		echo "kernel-copy"
		exit
	;;
		
esac

