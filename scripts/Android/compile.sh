#!/bin/bash
DIR=$HOME/github/Android/kernel
KERNEL_DIR=$DIR/kernel_samsung_exynos9810-V2

# We do clean build here, ok
cd $KERNEL_DIR
rm -rf out/
mkdir out

make O=out ARCH=arm64 exynos9810-star2lte_defconfig

PATH="$DIR/clang/bin:$DIR/gcc.64/bin:$DIR/gcc.32/bin:${PATH}" \
make  -j$(nproc --all)   O=out \
        ARCH=arm64 \
        CC=clang \
        CLANG_TRIPLE=aarch64-linux-gnu- \
        CROSS_COMPILE=aarch64-linux-android- \
        CROSS_COMPILE_ARM32=arm-linux-androideabi- \
        LLVM=1 \
