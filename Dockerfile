FROM ubuntu:focal as builder-riscv-toolchain
ARG DEBIAN_FRONTEND=noninteractive
ARG num_jobs=1

ENV PATH=$RISCV/bin:$PATH

RUN apt update && apt upgrade -y
RUN apt install -y build-essential autoconf automake autotools-dev python3 python3-pip libmpc-dev libmpfr-dev libgmp-dev gawk bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build git cmake libglib2.0-dev curl device-tree-compiler curl libmpc-dev 

WORKDIR /root
RUN git clone --recursive https://github.com/riscv-collab/riscv-gnu-toolchain
WORKDIR riscv-gnu-toolchain
RUN ./configure --with-arch=rv32gc --with-abi=ilp32 --enable-multilib --prefix=/opt/riscv-cross && make linux -j $num_jobs && make clean

# Spike
RUN apt install -y build-essential autoconf automake autotools-dev python3 python3-pip libmpc-dev libmpfr-dev libgmp-dev gawk bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build git cmake libglib2.0-dev curl device-tree-compiler
WORKDIR /root
RUN git clone https://github.com/riscv-software-src/riscv-isa-sim
WORKDIR riscv-isa-sim
RUN ./configure --prefix=/opt/spike && make -j $num_jobs && make install && make clean

# LLVM

WORKDIR /llvm-upstream
RUN apt install -y wget lsb-release software-properties-common
RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN /llvm-upstream/llvm.sh 17
