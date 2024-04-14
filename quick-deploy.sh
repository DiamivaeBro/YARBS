#!/usr/bin/env bash

greetings () {
    echo -e "\033[1;33m YY      YY   AAAAA      RRRRRR     BBBB       SSSS \033[0m"
    sleep 0.5;
    echo -e "\033[1;33m   YY  YY     AA  AA     RR    RR   BB  BB   SS    S\033[0m"
    sleep 0.5;
    echo -e "\033[1;33m     YY       AA   AA    RRRRRR     BBBB       SSS  \033[0m"
    sleep 0.5;
    echo -e "\033[1;33m     YY       AAAAAAAA   RR   RR    BB  BB   S    SS\033[0m"
    sleep 0.5;
    echo -e "\033[1;33m     YY       AA     AA  RR     RR  BBBBBB    SSSS  \033[0m"
    sleep 1;
}

check () {
    if ! [ $(id -u) = 0 ]; then
        echo -e "\033[1;33mRun me as a root.\033[0m"
        exit 1
    fi
}

workdir () {
    echo -e "\033[1;33mCreating workdir in /.\033[0m"
    mkdir /workdir
    chmod 777 /workdir/
    chown root /workdir/
    cd /workdir 
}

debootstarpping () {
    echo -e "\033[1;33mAcquiring Base Ubuntu image.\033[0m"
    debootstrap --arch=amd64 --no-check-certificate --no-check-gpg --include=git,systemd,systemd-container jammy /workdir http://mirror.yandex.ru/ubuntu/
}

cloning () {
    mkdir -p /workdir/builddir
    echo -e "\033[1;33mAcquiring script.\033[0m"
    cp ./* /workdir/builddir
}

nspawn () {
    echo -e "\033[1;33mNow we run systemd-nspawn:\033[0m"
    systemd-nspawn -D /workdir /bin/bash -c 'export PATH="/usr/bin:$PATH"; bash build_ksu.sh'
    umount -l /workdir
}

greetings
check
workdir
debootstarpping
cloning
nspawn
echo -e "\033[1;33mDone!\033[0m"