## Yet Another Redbull Build Script (YARBS)

Simple bash script for building android kernel!

Script can build:

```
- Build standart kernel for Google Redbull family
- Build custom kernel for Google Redbull family (initial support)
- Build kernel with KSU  (Patch and Kprobes methods)
- Build kernel with APatch fixes
- Pack builded kernel into AnyKernel3
```

## What in plans?

```
- Add support of build and patch kernels for most of android devices
- Make more flexible settings
- Add more avalible patches
```

## IT'S JUST ALPHA

Script really is not ideal and i need to rewrite some components. If you see any bugs, please report them on issues

## Setting up your machine

You must be running a 64-bit Linux distribution and must have installed some packages to build Kernel.
Google recommends using [Ubuntu](http://www.ubuntu.com/download/desktop) for this and provides instructions for setting up the system (with Ubuntu-specific commands) on [the Android Open Source Project website.](https://source.android.com/source/initializing.html#setting-up-a-linux-build-environment)

## Grabbing the source

[Repo](http://source.android.com/source/developing.html) is a tool provided by Google that simplifies using [Git](http://git-scm.com/book) in the context of the Android source.

```bash
# Make a directory where Repo will be stored and add it to the path
mkdir ~/.bin
PATH=~/.bin:$PATH

# Download Repo itself
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo

# Make Repo executable
chmod a+x ~/.bin/repo
```

Clone this repo to the home directory

```bash
git clone https://github.com/DiamivaeBro/YARBS.git
```

Start script

```bash
./$HOME/YARBS/build_ksu.sh
```

Then answer for some qutions and build starts

Results you can found in "AnyKernel3" and "out" directories in $HOME/android-kernel

You can configure for what android version kernel you building, just change branch at script

## Also in releases you can find prebuilded by me redbull kernels that includes KSU. A14 QPR1 ONLY

How to install?

Download latest kernel form releases (boot.img for stock, AnyKernel3 for custom roms)

1. For stock ROM

1.1 Unlock bootloader

1.2 Reboot to bootloader

1.3 Flash boot.img

```bash
fastboot flash boot boot.img
```

1.4 Boot to system

1.5 If it dont booted and ask to restore factory data you need to restore factory data

Congratulations! All might be okay

2. For custom ROM (Tested with [LineageOS](https://github.com/LineageOS) 21 may not work on others)

2.1. Reboot to recovery

2.2 Apply update

2.3 Apply update from ADB

2.4

```bash
adb sideload AnyKernel3.zip
```

2.5 Reboot to system

Congratulations! All might be okay

## I AM NOT RESPONSIBLE IF DEVICE BRICK OR BROKE. PROCEED AT YOUR OWN RISK.

## Thanks to:

- [AOSPA](https://github.com/AOSPA/manifest/blob/uvite/README.md) - for base README.
- [QKIvan](https://github.com/QKIvan) - For main logic of YARBS i refered to his worklow files
- [xiaoleGun](https://github.com/xiaoleGun) - Script for patch kernel sources to support KernelSU
- [Riko](https://codeberg.org/mikromikro) - Code refactoring
- [KernelSU Action](https://github.com/xiaoleGun/KernelSU_Action) - Idea of this project
- [KernelSU](https://github.com/tiann/KernelSU) - KernelSU realization
- [Tiann](https://github.com/tiann) - KSU Patches
- [AnyKernel3](https://github.com/osm0sis/AnyKernel3) - AnyKernel3 realization