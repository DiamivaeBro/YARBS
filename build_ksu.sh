#!/bin/bash
echo 'Preparing packages'
sudo apt-get update -y
mkdir $HOME/android-kernel
cd $HOME/android-kernel
if ! test -f $HOME/android-kernel/private/msm-google/AndroidKernel.mk; then
	echo "Downloading sources..."
	rm -rf "$HOME/.repo"
	repo init -u https://android.googlesource.com/kernel/manifest -b android-msm-redbull-4.19-android14-qpr1
	repo sync
else
	echo "Sources already downloaded"
fi
cd private/msm-google
read -p "Do you need KSU? y , n or Apatch: " KSU
if [[ "$KSU" == "y" ]]; then
echo "Including KSU"
read -p "What KSU method you need? kprobes or patch: " KSUMT
if [[ "$KSUMT" == "kprobes" ]]; then
if grep -q "CONFIG_KPROBES=y" private/msm-google/arch/arm64/configs/redbull_defconfig; then
	echo "KSU by kprobes included"
else
	echo "Including KSU kprobes method"
	echo "CONFIG_MODULES=y" >>arch/arm64/configs/redbull_defconfig
	echo "CONFIG_KPROBES=y" >>arch/arm64/configs/redbull_defconfig
	echo "CONFIG_HAVE_KPROBES=y" >>arch/arm64/configs/redbull_defconfig
	echo "CONFIG_KPROBE_EVENTS=y" >>arch/arm64/configs/redbull_defconfig
	echo "CONFIG_OVERLAY_FS=y" >>arch/arm64/configs/redbull_defconfig
fi
elif [[ "$KSUMT" == "patch" ]]; then
cd $HOME/private/msm-google
echo "CONFIG_KSU=y" >> arch/arm64/configs/redbull_defconfig
source $HOME/YARBS/patches.sh ;
else exit
elif [[ "$KSU" == "n" ]]; then
echo "Doing nothing"
elif [["$KSU" == "Apatch"]]
if grep -q "CONFIG_KALLSYMS=y" private/msm-google/arch/arm64/configs/redbull_defconfig; then
echo "Apatch fixes included"
else
echo "" >> arch/arm64/configs/redbull_defconfig
echo "" >> arch/arm64/configs/redbull_defconfig
echo "Added Apatch support"
fi
else echo "Doing nothing"
fi
fi
make ARCH=arm64 redbull-gki_defconfig
make ARCH=arm64 savedefconfig
make mrproper
cp defconfig arch/arm64/configs/redbull-gki_defconfig
if ! test -f "$HOME/android-kernel/private/msm-google/KernelSU/justfile"; then
	echo "Dowloading KSU sources"
	curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -
else
	echo "KSU sources already downloaded"
fi
##Build kernel
cd $HOME/android-kernel
if test -f $HOME/android-kernel/out; then
	rm -rf "out"
fi
if test -f $HOME/android-kernel/AnyKernel3; then
	rm -rf "AnyKernel3"
fi
 source build_redbull-gki.sh
##Setup AnyKernel
cd /home/runner/android-kernel
git clone https://github.com/osm0sis/AnyKernel3.git
sed -i 's/do.devicecheck=1/do.devicecheck=0/g' AnyKernel3/anykernel.sh
sed -i 's!block=/dev/block/platform/omap/omap_hsmmc.0/by-name/boot;!block=auto;!g' AnyKernel3/anykernel.sh
sed -i 's/is_slot_device=0;/is_slot_device=auto;/g' AnyKernel3/anykernel.sh
cp $HOME/android-kernel/out/android-msm-pixel-4.19/dist/Image.lz4-dtb AnyKernel3/
cd ./AnyKernel3/
zip -r AnyKernel3 . -x ".git*" -x "README.md" -x "*.zip"
echo "All done.Check $HOME/android-kernel/AnyKernel"
