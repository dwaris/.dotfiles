#!/bin/bash
DIR=$HOME/github/Android/kernel
KERNEL_DIR=$DIR/kernel_samsung_exynos9810-V2
AIK_DIR=$DIR/AIK-Linux

# copy
cp $KERNEL_DIR/out/arch/arm64/boot/Image $AIK_DIR/split_img/boot.img-kernel
cp $KERNEL_DIR/out/arch/arm64/boot/dts/exynos/exynos9810-star2lte_eur_open_26.dtb $AIK_DIR/split_img/boot.img-dt

# repacking
$AIK_DIR/repackimg.sh
