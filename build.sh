#!/bin/bash
echo "Starting build"
rm -rf out/arch/arm64/boot/Image.gz-dtb
export LC_ALL=C && export USE_CCACHE=1
ccache -M 100G >/dev/null
export ARCH=arm64
clangbin=clang/bin/clang
if ! [ -a $clangbin ]; then git clone --depth=1 https://gitlab.com/reaPeR1010/android_prebuilts_clang_host_linux-x86_clang-r563880 clang
fi

make O=out ARCH=arm64 mt6893_defconfig

PATH="${PWD}/clang/bin:${PATH}" \
make -j$(nproc --all)   O=out \
                        ARCH=arm64 \
                        CC="clang" \
                        LLVM=1 \
                        LLVM_IAS=1 \
                        CONFIG_NO_ERROR_ON_MISMATCH=y

zimage=out/arch/arm64/boot/Image.gz-dtb
if ! [ -a $zimage ];
then
echo  "Build failed"
else
anykernelbin=AnyKernel/anykernel.sh
if ! [ -a $anykernelbin ]; then git clone --depth=1 https://github.com/liwhy1/AnyKernel3 -b cupida AnyKernel
fi
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
cd AnyKernel
zip -r9 ORIGIN-OSS-KERNEL-RMX3031.zip *
cd ../
fi