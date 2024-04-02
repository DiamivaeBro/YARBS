Yet Another Redbull Build Script (YARBS)
-------------

Simple bash script for building android kernels!

For now script can

* Build standart kernel for Google Redbull family
* Build standart kernel with KSU  (Patch and Kprobes methods)
* Pack builded kernel into AnyKernel3
  
What in planes?
-------------

* Add support of build and patch kernels for most of android devices
* Make more flexible settings
* Add more avalible patches

I'TS JUST FIRST ALPFA
-------------
Script realy not ideal and i need to rewrite some components,if you see bug please make issue

How to use?
-------------

You need latest Ubuntu enviroment, you can use WSL (For windows) or Docker (Linux,Mac Os, Windows and etc.)
Prepare pakages
```bash
sudo apt-get install -y repo git
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

Also in releases you can find prebuilded by me redbull kernels that includes KSU
-------------

How to install?

Download latest kernel form releases (boot.img for stock,AnyKernel3 for custom roms)

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

2. For custom ROM (Tested with LinageOs 21 may not work on others)

2.1. Reboot to recovery

2.2 Apply update

2.3 Apply update from ADB 

2.4
```bash
adb sideload AnyKernel3.zip
```

2.5 Reboot to system

Congratulations! All might be okay

I AM NOT RESPONSIBLE IF DEVICE BRICK OR BROKE. PROCEED AT YOUR OWN RISK.
-------------

Thanks to:
-------------
- [QKIvan](https://github.com/QKIvan) - For main logic of YARBS i refered to his worklow files
- [xiaoleGun](https://github.com/xiaoleGun) - Script for patch kernel sources to support KernelSU
- [KernelSU Action](https://github.com/xiaoleGun/KernelSU_Action) - Idea of this project
- [KernelSU](https://github.com/tiann/KernelSU) - KernelSU realization
- [Tiann](https://github.com/tiann) - KSU Patches

