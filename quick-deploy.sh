#!/usr/bin/env bash

greetings () {
    echo -e "\033[31m YY      YY   AAAAA      RRRRRR     BBBB       SSSS \033[0m"
    sleep 0.5;
    echo -e "\033[31m   YY  YY     AA  AA     RR    RR   BB  BB   SS    S\033[0m"
    sleep 0.5;
    echo -e "\033[31m     YY       AA   AA    RRRRRR     BBBB       SSS  \033[0m"
    sleep 0.5;
    echo -e "\033[31m     YY       AAAAAAAA   RR   RR    BB  BB   S    SS\033[0m"
    sleep 0.5;
    echo -e "\033[31m     YY       AA     AA  RR     RR  BBBBBB    SSSS  \033[0m"
    sleep 1;
}

check () {
    if ! [ $(id -u) = 0 ]; then
        echo "\033[31mRun me as a root.\033[0m"
        exit 1
    fi
}

workdir () {
    echo "\033[31mCreating workdir in /.\033[0m"
    mkdir /workdir
    chmod 777 /workdir/
    chown root /workdir/
    cd /workdir 
}

debootstarpping () {
    echo "\033[31mAcquiring Base Ubuntu image.\033[0m"
    debootstrap --arch=amd64 --no-check-certificate --no-check-gpg --include=git,systemd,systemd-container jammy /workdir http://mirror.yandex.ru/ubuntu/
}

cloning () {
    mkdir -p /workdir/builddir
    echo "\033[31mAcquiring script.\033[0m"
    cp ./* /workdir/builddir
}

nspawn () {
    echo "\033[31mNow we run systemd-nspawn:\033[0m"
    systemd-nspawn -D /workdir /bin/bash -c 'export PATH="/usr/bin:$PATH"; bash build_ksu.sh'
    umount -l /workdir
}

greetings
check
workdir
debootstarpping
cloning
nspawn
echo "\033[31mDone!\033[0m"