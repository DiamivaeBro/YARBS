FROM ubuntu:latest

LABEL maintainer="s0me1newithhand7s@gmail.com"

RUN apt-get update
RUN apt-get install -y git
RUN git clone https://github.com/DiamivaeBro/YARBS

CMD [ "bash", "YARBS/build_ksu.sh" ]
