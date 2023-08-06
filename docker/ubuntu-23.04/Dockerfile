FROM ubuntu:23.04

RUN apt update
RUN apt install -yqq build-essential
RUN apt install -yqq make
RUN apt install -yqq gcc
RUN apt install -yqq gcc-12
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 12
RUN apt install -y gccgo
RUN apt install -y gccgo-12
RUN update-alternatives --install /usr/bin/gccgo gccgo /usr/bin/gccgo-12 12
RUN apt install -yqq clang
RUN apt install -yqq python3
RUN apt install -yqq gawk sed
RUN apt install -yqq sudo less
RUN apt install -yqq libncurses5 libncurses5-dev libncursesw5
RUN apt install -yqq flex bison
RUN apt install -yqq wget ca-certificates
RUN apt install -yqq golang
RUN apt install -yqq unzip
RUN apt install -yqq vim
RUN apt install -yqq gcc-aarch64-linux-gnu
RUN apt install -yqq g++-aarch64-linux-gnu
RUN apt install -yqq uuid-runtime
RUN apt install -yqq qemu-system-x86
RUN apt install -yqq qemu-system-arm
RUN apt install -yqq sgabios

WORKDIR /workdir
