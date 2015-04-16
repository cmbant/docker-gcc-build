FROM ubuntu:14.04

MAINTAINER Antony Lewis

RUN apt-get update \
 && apt-get install -y \
     bison \
     build-essential \
     flex \
     g++ \
     git \
     libmpc-dev \
 && apt-get clean 
RUN git clone git://gcc.gnu.org/git/gcc.git \
 && cd gcc \
 && mkdir objdir \
 && cd objdir \
 && ../configure --enable-languages=c,c++,fortran --disable-multilib \
 && make bootstrap -j 2 \
 && sudo make install \
 && make distclean \
