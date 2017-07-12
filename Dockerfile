FROM ubuntu:latest

MAINTAINER Antony Lewis

RUN apt-get update && apt-get install -y \
     build-essential \
     git \
     liblapack-dev \
     libopenblas-dev \
     openmpi-bin \
     libopenmpi-dev \
 && apt-get clean

ADD https://gcc.gnu.org/git/?p=gcc.git;a=shortlog;h=refs/heads/master gcc_shortlog

RUN buildDeps='wget unzip bison flex libmpc-dev g++ ' \
 && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
 && wget https://codeload.github.com/gcc-mirror/gcc/zip/master \
 && unzip  master \
 && rm -f master  \
 && cd gcc-master  \
 && mkdir objdir \
 && cd objdir \
 && ../configure --enable-languages=c,c++,fortran --disable-multilib \
    --disable-bootstrap --build=x86_64-linux-gnu \
 && make -j"$(nproc)" \
 && make install \
 && make distclean \
 && cd ../.. \
 && rm -rf ./gcc-master  \
 && sed -i '1s/^/\/usr\/local\/lib64\n/' /etc/ld.so.conf \
 && ldconfig \
 && apt-get purge -y --auto-remove $buildDeps \
 && apt-get update \
 && apt-get install -y build-essential \
 && apt-get clean \
 && gcc --version
