#!/usr/bin/env bash
# Preparing variables
BUILD_HOME=$HOME/builddir
KERNEL_DIR=$BUILD_HOME/android-kernel
SOURCE_KERNEL_DIR=${KERNEL_DIR}/private/msm-google
DEVICE_DEFCONFIG=${SOURCE_KERNEL_DIR}/arch/arm64/configs/redbull_defconfig
ARCH=arm64
LOGGING=0

# Making functions
greetings() {
    echo -e "    "
    sleep 0.5
    echo -e "\033[1;33m YY      YY   AAAAA      RRRRRR     BBBB       SSSS \033[0m"
    sleep 0.5
    echo -e "\033[1;33m   YY  YY     AA  AA     RR    RR   BB  BB   SS    S\033[0m"
    sleep 0.5
    echo -e "\033[1;33m     YY       AA   AA    RRRRRR     BBBB       SSS  \033[0m"
    sleep 0.5
    echo -e "\033[1;33m     YY       AAAAAAAA   RR   RR    BB  BB   S    SS\033[0m"
    sleep 0.5
    echo -e "\033[1;33m     YY       AA     AA  RR     RR  BBBBBB    SSSS  \033[0m"
    echo -e "    "
    sleep 1
}

select_kernel_type() {
    read -p "What kernel do you want to build? (stock/custom) " KERNEL_TYPE
}

select_kernel_patch() {
    read -p "Do you want to include any kernel patches? (kernelsu/apatch/none) " KPATCH_TYPE
    if [[ "$KPATCH_TYPE" == "kernelsu" ]]; then
        merge_ksu
        echo "Including KernelSu"
    elif [[ "$KPATCH_TYPE" == "apatch" ]]; then
        merge_apatch
        echo "Including Apatch"
    elif [[ "$KPATCH_TYPE" == "none" ]]; then
        cd $SOURCE_KERNEL_DIR
        echo "Building without patches"
    else
        select_kernel_patch
    fi
}

merge_ksu_kprobe() {
    CHECK_MODULES=$(cat $DEVICE_DEFCONFIG | grep -w CONFIG_MODULES | awk -F= '{printf $2}')
    if [ ${CHECK_MODULES} == "n" ]; then
        sed -i "s/CONFIG_MODULES=n/CONFIG_MODULES=y/" $DEVICE_DEFCONFIG
    elif [ ${CHECK_MODULES} == "" ]; then
        echo "CONFIG_MODULES=y" >>$DEVICE_DEFCONFIG
    else
        echo ""
    fi
    CHECK_KPROBES=$(cat $DEVICE_DEFCONFIG | grep -w CONFIG_KPROBES | awk -F= '{printf $2}')
    if [ ${CHECK_KPROBES} == "n" ]; then
        sed -i "s/CONFIG_KPROBES=n/CONFIG_KPROBES=y/" $DEVICE_DEFCONFIG
    elif [ ${CHECK_KPROBES} == "" ]; then
        echo "CONFIG_KPROBES=y" >>$DEVICE_DEFCONFIG
    else
        echo ""
    fi
    CHECK_HAVE_KPROBES=$(cat $DEVICE_DEFCONFIG | grep -w CONFIG_HAVE_KPROBES | awk -F= '{printf $2}')
    if [ ${CHECK_HAVE_KPROBES} == "n" ]; then
        sed -i "s/CONFIG_HAVE_KPROBES=n/CONFIG_HAVE_KPROBES=y/" $DEVICE_DEFCONFIG
    elif [ ${CHECK_HAVE_KPROBES} == "" ]; then
        echo "CONFIG_HAVE_KPROBES=y" >>$DEVICE_DEFCONFIG
    else
        echo ""
    fi
    CHECK_KPROBE_EVENTS=$(cat $DEVICE_DEFCONFIG | grep -w CONFIG_KPROBE_EVENTS | awk -F= '{printf $2}')
    if [ ${CHECK_KPROBE_EVENTS} == "n" ]; then
        sed -i "s/CONFIG_KPROBE_EVENTS=n/CONFIG_KPROBE_EVENTS=y/" $DEVICE_DEFCONFIG
    elif [ ${CHECK_KPROBE_EVENTS} == "" ]; then
        echo "CONFIG_KPROBE_EVENTS=y" >>$DEVICE_DEFCONFIG
    else
        echo ""
    fi
    CHECK_OVERLAY_FS=$(cat $DEVICE_DEFCONFIG | grep -w CONFIG_OVERLAY_FS | awk -F= '{printf $2}')
    if [ ${CHECK_OVERLAY_FS} == "n" ]; then
        sed -i "s/CONFIG_OVERLAY_FS=n/CONFIG_OVERLAY_FS=y/" $DEVICE_DEFCONFIG
    elif [ ${CHECK_OVERLAY_FS} == "" ]; then
        echo "CONFIG_OVERLAY_FS=y" >>$DEVICE_DEFCONFIG
    else
        echo ""
    fi
}

merge_ksu_patch() {
    cd $SOURCE_KERNEL_DIR
    echo "CONFIG_KSU=y" >>$DEVICE_DEFCONFIG
    bash $HOME/YARBS/patches.sh
}

check_ksu_patch_type() {
    read -p "KSU supports two patching methods. What method do you want to use? (kprobes/patch): " KPATCH_KSU_METHOD
    if [ ${KPATCH_KSU_METHOD} == "kprobes" ]; then
        merge_ksu_kprobe

    elif [ ${KPATCH_KSU_METHOD} == "patch" ]; then
        merge_ksu_patch

    else
        echo ""
    fi
}

merge_ksu() {
    cd $SOURCE_KERNEL_DIR
    if [ ! -f "KernelSU/justfile" ]; then
        curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -s v0.9.5
        check_ksu_patch_type
    else
        check_ksu_patch_type
    fi

}

merge_apatch() {
    echo "CONFIG_KALLSYMS=y" >>$DEVICE_DEFCONFIG
    echo "CONFIG_KALLSYMS_ALL=y" >>$DEVICE_DEFCONFIG
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
    if [ ${FTBE} == "y" ]; then
        sudo apt-get update -y
        sudo apt-get install libssl-dev git systemtap gcc flex
    else
        echo ""
    fi
}

install_buildroot() {
    if [ ! -d $KERNEL_DIR ]; then
        echo "Downloading buildroot..."
        git clone https://github.com/DiamivaeBro/YARBS_BuildRoot.git $KERNEL_DIR
    else
        echo "Buildroot alredy downloaded!"
    fi
    if [ ! -d $KERNEL_DIR/prebuilts-master/clang ]; then
        echo "Downloading clang..."
        git clone https://github.com/DiamivaeBro/YARBS_Clang.git $KERNEL_DIR/prebuilts-master/clang
    else
        echo "Clang already downloaded!"
    fi
    cd $KERNEL_DIR
}

stock_kernel_merge() {
    if [ ! -f $SOURCE_KERNEL_DIR/stock ]; then
        git clone https://github.com/DiamivaeBro/android_kernel_redfin_stock.git $KERNEL_DIR/private/msm-google
        touch $SOURCE_KERNEL_DIR/stock
    elif [ -d $KERNEL_DIR/private/msm-google-stock ]; then
        mv $KERNEL_DIR/private/msm-google-stock $KERNEL_DIR/private/msm-google
    else
        echo "You already have stock kernel sources!"
    fi
    disable_chekdefconfig
    cd $SOURCE_KERNEL_DIR

}

custom_kernel_merge() {
    if [ -f $SOURCE_KERNEL_DIR/stock ]; then
        mv $KERNEL_DIR/private/msm-google $KERNEL_DIR/private/msm-google_stock
    else
        echo ""
    fi
    cd $KERNEL_DIR/private
    read -p "Enter link to sources: " KGIT
    read -p "Enter branch name: " KBRANCH
    git clone "$KGIT" $SOURCE_KERNEL_DIR -b "$KBRANCH"
    cd $SOURCE_KERNEL_DIR
    disable_chekdefconfig
}

disable_chekdefconfig() {
    echo "Disabling check_defconfig function..."
    if [ ${AGKI} == "y" ]; then
        BUILDCONFIG=$SOURCE_KERNEL_DIR/build.config.redbull.vintf
    else
        BUILDCONFIG=$SOURCE_KERNEL_DIR/build.config.redbull.no-cfi
    fi
    DISSAVEDEFCONF=$(cat $BUILDCONFIG | grep -wo check_defconfig)
    if [ ${DISSAVEDEFCONF} == "check_defconfig" ]; then
        sed -i "s/check_defconfig//" $BUILDCONFIG
        sed -i "3 s/&&//" $BUILDCONFIG

    else
        echo "check_defconfig function already disabled!"
    fi
}

check_kernel_type() {
    if [ ${KERNEL_TYPE} == "stock" ]; then
        stock_kernel_merge
    elif [ ${KERNEL_TYPE} == "custom" ]; then
        custom_kernel_merge
    else
        select_kernel_type
        check_kernel_type
    fi
}

save_defconfig() {
    make ARCH=arm64 ${DEVICE_DEFCONFIG}
    make ARCH=arm64 savedefconfig
    make mrproper
    cp defconfig ${SOURCE_KERNEL_DIR}/arch/arm64/configs/defconfig
}

sources_clean() {
    cd $KERNEL_DIR
    if [ -d $KERNEL_DIR/out ]; then
        rm -rf out
    fi
    if [ -d $KERNEL_DIR/AnyKernel3 ]; then
        rm -rf AnyKernel3
    fi
}

setup_anykernel_scripts() {
    cd $KERNEL_DIR
    git clone https://github.com/osm0sis/AnyKernel3.git
    sed -i 's/do.devicecheck=1/do.devicecheck=0/g' AnyKernel3/anykernel.sh
    sed -i 's!block=/dev/block/platform/omap/omap_hsmmc.0/by-name/boot;!block=auto;!g' AnyKernel3/anykernel.sh
    sed -i 's/is_slot_device=0;/is_slot_device=auto;/g' AnyKernel3/anykernel.sh
    cp $BUILD_HOME/android-kernel/out/android-msm-pixel-4.19/dist/Image.lz4-dtb AnyKernel3/
    cd ./AnyKernel3/
    zip -r AnyKernel3 . -x ".git*" -x "README.md" -x "*.zip"
    echo "All done.Check $BUILD_HOME/android-kernel/AnyKernel"
}

build_log() {
    cd $KERNEL_DIR
    if [ ${LOGGING} == "1" ]; then
        echo "Build with logging to logcat.log"
        bash build_redbull${GKI}.sh >logcat.log
    elif [ ${LOGGING} == "0" ]; then
        echo "Build without logging"
        bash build_redbull${GKI}.sh
    fi
}

ask_for_gki() {
    read -p "Do you need GKI (recomended for stock) y/n " AGKI
    if [ ${AGKI} == "y" ]; then
        GKI=-gki
        echo "Building GKI"
    elif [ ${AGKI} == "n" ]; then
        echo "Building without GKI"
    else
        ask_for_gki
    fi
}

###Starting script
greetings
mkdir $HOME/builddir
update_system
install_buildroot
ask_for_gki
select_kernel_type
check_kernel_type
select_kernel_patch
save_defconfig
sources_clean
build_log
setup_anykernel_scripts
