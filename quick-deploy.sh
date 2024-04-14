#!/usr/bin/env bash

greetings () {
    echo -e "\033[31m YY      YY   AAAAA      RRRRRR     BBBB         SSSS  \033[0m"
    echo -e "\033[31m   YY  YY     AA  AA     RR    RR   BB  BB     SS     S\033[0m"
    echo -e "\033[31m     YY       AA   AA    RRRRRR     BBBB          SS   \033[0m"
    echo -e "\033[31m     YY       AAAAAAAA   RR   RR    BB  BB     S    SS \033[0m"
    echo -e "\033[31m     YY       AA     AA  RR     RR  BBBBBB      SSSS   \033[0m"
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
    debootstrap --arch=amd64 --no-check-certificate --include=sudo,git,systemd jammy /workdir http://mirror.yandex.ru/ubuntu/
}

sciptnrun () {
    if [ -f /workdir/etc/os-release ]; then
        echo "Now we run systemd-nspawn."
        systemd-nspawn --read-only -D /workdir 
        source /etc/profile
        mkdir -p /builddir
        echo "Acquiring script."
        git clone "https://github.com/DiamivaeBro/YARB.git /workdir"
        bash /builddir/YARBS/build_ksu.sh
        exit
    else
        echo "An error occured! Retry pls."
        exit 1
    fi
}

check
workdir
debootstarpping
sciptnrun
umount /workdir
echo "Done!"