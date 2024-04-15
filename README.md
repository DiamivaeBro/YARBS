<p align="center"><img src=https://github.com/DiamivaeBro/YARBS/assets/117505144/52106683-6a10-4f84-b26d-c10c627794d2></p>
<h1 align="center">Yet Another Redbull Build Script (YARBS) 🦊</h1>
<h3 align="center">Simple bash script for building android kernels!</h3>
<br>
<h2 align="center">▶️ Script features:</h2>

- Build standart kernel for Google Redbull family
- Build custom kernel for Google Redbull family (initial support)
- Build kernel with KSU  (Patch and Kprobes methods)
- Build kernel with APatch fixes
- Pack builded kernel into AnyKernel3

  <br>

<h2 align="center">▶️ Future plans:</h2>

- Add support of build and patch kernels for most of android devices
- Make more flexible settings
- Add more avalible patches

  <br>

<h1 align="center">⚠️ WE NOT RESPONSIBLE IF DEVICE BRICK OR BROKE. PROCEED AT YOUR OWN RISK.⚠️</h1>
<h3>THIS SCRIPT IS IN EARLY TESTING AND MAY CAUSE DAMAGE TO YOUR DEVICE IF USED INAPPROPRIATE. CONSIDER ALL RISKS AND USE IT AT YOUR FULL RESPONSE.</h3>
<h3>DO NOT OPEN NEW ISSUE IF YOU HAVE BRICKED DEVICE.</h3>
<br>
<br>
<br>
<h2 align="center">❔How to build?</h2>
<p>
You must be running a 64-bit Linux distribution and must have installed some packages to build Kernel.
Google recommends using Ubuntu.
</p>
<h2>Setup machine</h2>

```bash
sudo curl --create-dirs -L -o /usr/local/bin/repo -O -L https://storage.googleapis.com/git-repo-downloads/repo
sudo chmod a+rx /usr/local/bin/repo
sudo apt-get install -y curl bc flex bison git cmake build-essential 
```

<h2>Clone this repo to the home directory</h2>

```bash
git clone https://github.com/DiamivaeBro/YARBS.git
```

<h2>Start script</h2>

```bash
./$HOME/YARBS/build_ksu.sh
```

<h3>Then answer for some qutions and build starts</h3>
<br>

- Results you can found in "AnyKernel3" and "out" directories in $HOME/android-kernel
- You can configure for what android version kernel you building, just change branch at script
- Also in releases you can find prebuilded by me redbull kernels that includes KSU. A14 QPR1 ONLY

---

<h2 align="center">❔ How to install? </h2>
<h3>Download latest kernel form releases (boot.img for stock,AnyKernel3 for custom roms)</h3>

<b align="center">1. For stock ROM:</b>

1. Unlock bootloader

2. Reboot to bootloader

3. Flash boot.img

```bash
fastboot flash boot boot.img
```

4. Boot to system

5 If it dont booted and ask to restore factory data you need to restore factory data

<h3>Congratulations! All might be okay</h3>

<b align="center">2. For custom ROM (Tested with LinageOs 21 may not work on others)</b>

1. Reboot to recovery

2. Apply update

3. Apply update from ADB

4. Complete installing

```bash
adb sideload AnyKernel3.zip
```

5. Reboot to system

<h3>Congratulations! All might be okay</h3>
<br>
<h1 align="center">▶️ Thanks to:</h1>

- [QKIvan](https://github.com/QKIvan) - For main logic of YARBS i refered to his worklow files
- [xiaoleGun](https://github.com/xiaoleGun) - Script for patch kernel sources to support KernelSU
- [Riko](https://codeberg.org/mikromikro) - Code refactoring
- [KernelSU Action](https://github.com/xiaoleGun/KernelSU_Action) - Idea of this project
- [KernelSU](https://github.com/tiann/KernelSU) - KernelSU realization
- [Tiann](https://github.com/tiann) - KSU Patches
- [AnyKernel3](https://github.com/osm0sis/AnyKernel3) - AnyKernel3 realization