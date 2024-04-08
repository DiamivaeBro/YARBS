#!/usr/bin/env bash
# Preparing variables
KERNEL_DIR=$HOME/android-kernel
SOURCE_KERNEL_DIR=${KERNEL_DIR}/private/msm-google
DEVICE_DEFCONFIG=arch/arm64/configs/redbull_defconfig
ARCH=arm64

# Making functions
change_dir() {
	cd $KERNEL_DIR
}

select_kernel_type() {
	read -p "What kernel do you want to build? (stock/custom)" KERNEL_TYPE
}

select_kernel_patch() {
	read -p "Do you want to include any kernel patches? (kernelsu/apatch/none) " KPATCH_TYPE
	if  [[ "$KPATCH_TYPE" == "kernelsu" ]]; then
	merge_ksu
	echo "Including KernelSu"
	elif [[ "$KPATCH_TYPE" == "apatch" ]]; then
merge_apatch
echo "Including Apatch"
elif [[ "$KPATCH_TYPE" == "none" ]]; then
echo "Building without patches"
else select_kernel_patch
fi
}

merge_ksu_kprobe() {
	CHECK_MODULES=$(cat $DEVICE_DEFCONFIG | grep -w CONFIG_MODULES | awk -F= '{printf $2}')
	if [ ${CHECK_MODULES} == "n" ]; then
		sed -i "s/CONFIG_MODULES=n/CONFIG_MODULES=y/" $DEVICE_DEFCONFIG
	elif [ ${CHECK_MODULES} == "" ]; then
		echo "CONFIG_MODULES=y" >> $DEVICE_DEFCONFIG
	else
		echo ""
	fi
	CHECK_KPROBES=$(cat $DEVICE_DEFCONFIG | grep -w CONFIG_KPROBES | awk -F= '{printf $2}')
	if [ ${CHECK_KPROBES} == "n" ]; then
		sed -i "s/CONFIG_KPROBES=n/CONFIG_KPROBES=y/" $DEVICE_DEFCONFIG
	elif [ ${CHECK_KPROBES} == "" ]; then
		echo "CONFIG_KPROBES=y" >> $DEVICE_DEFCONFIG
	else
		echo ""
	fi
	CHECK_HAVE_KPROBES=$(cat $DEVICE_DEFCONFIG | grep -w CONFIG_HAVE_KPROBES | awk -F= '{printf $2}')
	if [ ${CHECK_HAVE_KPROBES} == "n" ]; then
		sed -i "s/CONFIG_HAVE_KPROBES=n/CONFIG_HAVE_KPROBES=y/" $DEVICE_DEFCONFIG
	elif [ ${CHECK_HAVE_KPROBES} == "" ]; then
		echo "CONFIG_HAVE_KPROBES=y" >> $DEVICE_DEFCONFIG
	else
		echo ""
	fi
	CHECK_KPROBE_EVENTS=$(cat $DEVICE_DEFCONFIG | grep -w CONFIG_KPROBE_EVENTS | awk -F= '{printf $2}')
	if [ ${CHECK_KPROBE_EVENTS} == "n" ]; then
		sed -i "s/CONFIG_KPROBE_EVENTS=n/CONFIG_KPROBE_EVENTS=y/" $DEVICE_DEFCONFIG
	elif [ ${CHECK_KPROBE_EVENTS} == "" ]; then
		echo "CONFIG_KPROBE_EVENTS=y" >> $DEVICE_DEFCONFIG
	else
		echo ""
	fi
	CHECK_OVERLAY_FS=$(cat $DEVICE_DEFCONFIG | grep -w CONFIG_OVERLAY_FS | awk -F= '{printf $2}')
	if [ ${CHECK_OVERLAY_FS} == "n" ]; then
		sed -i "s/CONFIG_OVERLAY_FS=n/CONFIG_OVERLAY_FS=y/" $DEVICE_DEFCONFIG
	elif [ ${CHECK_OVERLAY_FS} == "" ]; then
		echo "CONFIG_OVERLAY_FS=y" >> $DEVICE_DEFCONFIG
	else
		echo ""
	fi
}

merge_ksu_patch() {
	echo "CONFIG_KSU=y" >> $DEVICE_DEFCONFIG
	bash patches.sh
}

check_ksu_patch_type() {
read -p "KSU supports two patching methods. What method do you want to use? (kprobes/patch): " KPATCH_KSU_METHOD
	if [ ${KPATCH_KSU_METHOD} == "kprobes" ]; then
merge_ksu_kprobe

	elif [ ${KPATCH_KSU_METHOD} == "patch" ]; then
merge_ksu_patch

	else
		echo "IDK"
fi
}

merge_ksu() {
	cd ${SOURCE_KERNEL_DIR}
	if [ ! -f ] "KernelSU/justfile"; then
		curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -
	check_ksu_patch_type
	else
	check_ksu_patch_type
	fi

}

merge_apatch() {
echo "CONFIG_KALLSYMS=y" >> arch/arm64/configs/redbull_defconfig
echo "CONFIG_KALLSYMS_ALL=y" >> arch/arm64/configs/redbull_defconfig
echo "Added Apatch support"

}

check_kernel_patch() {
	if [ ${KPATCH_TYPE} == "kernelsu" ]; then
merge_ksu
	elif [ ${KPATCH_TYPE} == "apatch" ]; then
merge_apatch
elif [ ${KPATCH_TYPE} == "none" ]; then
echo "Doing nothing"
	else
		select_kernel_patch
		check_kernel_patch
	fi
}

update_system() {
	sudo apt-get update -y
}

download_kernel_sources() {
	if [ ! -f ] private/msm-google/AndroidKernel.mk; then
		echo "Downloading sources..."
		rm -rf "$KERNEL_DIR/.repo"
		repo init -u https://android.googlesource.com/kernel/manifest -b android-msm-redbull-4.19-android14-qpr1
		repo sync -j $(nproc)
else
echo ""
fi
}

custom_kernel_merge() {
cd $SOURCE_KERNEL_DIR
git config --global user.email "local@github-example.com"
git init
          git config --global user.name "local-git"
	read -p "Enter link to sources: " KGIT
	read -p "Enter branch name: " KBRANCH
	          git remote add lk $KGIT
	git fetch lk
	git merge lk/$KBRANCH
	cd $KERNEL_DIR
}

check_kernel_type() {
	if [ ${KERNEL_TYPE} == "stock" ]; then
		echo "Building stock"
	elif [ ${KERNEL_TYPE} == "custom" ]; then
		custom_kernel_merge
	else
		select_kernel_type
		check_kernel_type
	fi
}

save_defconfig() {
make  redbull_defconfig
make ARCH=arm64 savedefconfig
make mrproper
cp defconfig arch/arm64/configs/redbull_defconfig
}

sources_clean() {
cd $HOME/android-kernel
if [ -f $HOME/android-kernel/out ] ; then
	rm -rf "out"
fi
if [ -f $HOME/android-kernel/AnyKernel3 ] ; then
	rm -rf "AnyKernel3"
fi
}

setup_anykernel_scripts() {
cd $KERNEL_DIR
git clone https://github.com/osm0sis/AnyKernel3.git
sed -i 's/do.devicecheck=1/do.devicecheck=0/g' AnyKernel3/anykernel.sh
sed -i 's!block=/dev/block/platform/omap/omap_hsmmc.0/by-name/boot;!block=auto;!g' AnyKernel3/anykernel.sh
sed -i 's/is_slot_device=0;/is_slot_device=auto;/g' AnyKernel3/anykernel.sh
cp $HOME/android-kernel/out/android-msm-pixel-4.19/dist/Image.lz4-dtb AnyKernel3/
cd ./AnyKernel3/
zip -r AnyKernel3 . -x ".git*" -x "README.md" -x "*.zip"
echo "All done.Check $HOME/android-kernel/AnyKernel"
}

mkdir android-kernel
update_system
change_dir
download_kernel_sources
select_kernel_type
check_kernel_type
select_kernel_patch
save_defconfig
sources_clean
bash build_redbull.sh
setup_anykernel_scripts
