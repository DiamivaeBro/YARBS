#!/usr/bin/env bash

greetings () {
    echo -e "    "
    sleep 0.5;
    echo -e "\033[1;33m YY      YY   AAAAA      RRRRRR     BBBB       SSSS \033[0m"
    sleep 0.5;
    echo -e "\033[1;33m   YY  YY     AA  AA     RR    RR   BB  BB   SS    S\033[0m"
    sleep 0.5;
    echo -e "\033[1;33m     YY       AA   AA    RRRRRR     BBBB       SSS  \033[0m"
    sleep 0.5;
    echo -e "\033[1;33m     YY       AAAAAAAA   RR   RR    BB  BB   S    SS\033[0m"
    sleep 0.5;
    echo -e "\033[1;33m     YY       AA     AA  RR     RR  BBBBBB    SSSS  \033[0m"
    echo -e "    "
    sleep 1;
}

check () {
    if ! [ $(id -u) = 0 ]; then
        echo -e "\033[1;33mRun me as a root.\033[0m"
        exit 1
    fi
}

localbuild () {
    docker build --tag build  -f  YARBS/Dockerfile .
}

runbuild() {
    docker run build
}

goodbye() {
    echo -e "    "
    sleep 0.5;
    echo -e "\033[1;33mDone!\033[0m"
    echo -e "    "
    sleep 1;
}

greetings
check
localbuild
runbuild
goodbye
