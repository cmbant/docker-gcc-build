FROM ubuntu:latest

MAINTAINER Izaak "Zaak" Beekman <contact@izaakbeekman.com>

ENV REFRESHED_AT 2016-11-22

RUN apt-get update && apt-get install --no-install-recommends -y \
     texinfo \
     unzip \
     wget \
 && apt-get clean

ENV APPS_REFRESHED_AT 2016-11-22

RUN apt-get update && apt-get install --no-install-recommends -y \
     build-essential \
     cmake \
     cmake-curses-gui \
     git \
     libmpich-dev \
     mpich \
 && apt-get clean

RUN buildDeps='bison flex libmpc-dev g++ libisl-dev libisl15 libmpfr-dev cloog' \
 && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
 && wget https://codeload.github.com/gcc-mirror/gcc/zip/master -nv \
 && unzip -a -o -DD master \
 && rm -f master \
 && cd gcc-master \
 && mkdir objdir \
 && cd objdir \
 && ../configure --enable-languages=c,c++,fortran --disable-multilib \
    --disable-bootstrap --build=x86_64-linux-gnu \
 && make -j"$(nproc)" \
 && make install \
 && make distclean \
 && cd ../.. \
 && rm -rf ./gcc-master \
 && sed -i '1s/^/\/usr\/local\/lib64\n/' /etc/ld.so.conf \
 && ldconfig \
 && apt-get purge -y --auto-remove $buildDeps

ENTRYPOINT ["/bin/bash"]

CMD ["-l"]
