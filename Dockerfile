FROM ubuntu:latest

MAINTAINER Antony Lewis

RUN apt-get update && apt-get install -y \
     build-essential \
     wget \
     git \
     liblapack-dev \
     libopenblas-dev \
     openmpi-bin \
     libopenmpi-dev \
 && apt-get clean

ADD https://gcc.gnu.org/git/?p=gcc.git;a=shortlog;h=refs/heads/master gcc_shortlog

RUN buildDeps='bison flex libmpc-dev g++ ' \
 && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
 && wget https://codeload.github.com/gcc-mirror/gcc/zip/gcc-6-branch \
 && unzip gcc-6-branch \
 && cd gcc-6-branch \
 && mkdir objdir \
 && cd objdir \
 && ../configure --enable-languages=c,c++,fortran --disable-multilib \
    --disable-bootstrap --build=x86_64-linux-gnu \
 && make -j"$(nproc)" \
 && make install \
 && make distclean \
 && cd ../.. \
 && rm -rf ./gcc-6-branch \
 && sed -i '1s/^/\/usr\/local\/lib64\n/' /etc/ld.so.conf \
 && ldconfig \
 && apt-get purge -y --auto-remove $buildDeps
