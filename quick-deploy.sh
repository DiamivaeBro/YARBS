#!/usr/bin/env bash

greetings () {
    echo -e "\033[31m YY      YY   AAAAA      RRRRRR     BBBB         SSSS \033[0m"
    echo -e "\033[31m   YY  YY     AA  AA     RR    RR   BB  BB     SS    S\033[0m"
    echo -e "\033[31m     YY       AA   AA    RRRRRR     BBBB          SS  \033[0m"
    echo -e "\033[31m     YY       AAAAAAAA   RR   RR    BB  BB     S    SS\033[0m"
    echo -e "\033[31m     YY       AA     AA  RR     RR  BBBBBB      SSSS  \033[0m"
    sleep 3;
}

check () {
    if ! [ $(id -u) = 0 ]; then
        echo "Run me as a root."
        exit 1
    fi
}

workdir () {
    echo "Creating workdir in /."
    mkdir /workdir
    chmod 777 /workdir/
    chown root /workdir/
    cd /workdir 
}

debootstarpping () {
    echo "Acquiring Base Ubuntu image."
    debootstrap --arch=amd64 --no-check-certificate --no-check-gpg --include=git,systemd,systemd-container jammy /workdir http://mirror.yandex.ru/ubuntu/
}

cloning () {
    mkdir -p /workdir/builddir
    echo "Acquiring script."
    cp ./* /workdir/builddir
}

nspawn () {
    echo "Now we run systemd-nspawn:"
    systemd-nspawn -D /workdir /bin/bash -c 'export PATH="/usr/bin:$PATH"; bash build_ksu.sh'
    umount -l /workdir
}

greetings
check
workdir
debootstarpping
cloning
nspawn
echo "Done!"