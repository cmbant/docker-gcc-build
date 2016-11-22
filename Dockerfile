FROM ubuntu:latest

MAINTAINER Izaak "Zaak" Beekman <contact@izaakbeekman.com>

ENV REFRESHED_AT 2016-11-22

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list

RUN apt-get update && apt-get install --no-install-recommends -y \
     texinfo \
     ca-certificates \
 && apt-get clean

ENV APPS_REFRESHED_AT 2016-11-22

RUN apt-get update && apt-get install --no-install-recommends -y \
     build-essential \
     cmake \
     cmake-curses-gui \
     git \
     openmpi-bin \
     libopenmpi-dev \     
 && apt-get clean

ARG VCS_REF

    LABEL org.label-schema.vcs-ref=$VCS_REF \
          org.label-schema.vcs-url="e.g. https://github.com/zbeekman/docker-gcc-build"

RUN buildDeps='bison flex libmpc-dev g++ ' \
 && apt-get update && apt-get install -y $buildDeps libisl15 --no-install-recommends \
 && git clone -q --single-branch --depth=1 https://github.com/gcc-mirror/gcc \
 && cd gcc \
 && mkdir objdir \
 && cd objdir \
 && ../configure --enable-languages=c,c++,fortran --disable-multilib \
    --disable-bootstrap --build=x86_64-linux-gnu \
 && make -j"$(nproc)" \
 && make install \
 && make distclean \
 && cd ../.. \
 && rm -rf ./gcc \
 && sed -i '1s/^/\/usr\/local\/lib64\n/' /etc/ld.so.conf \
 && ldconfig \
 && apt-get purge -y --auto-remove $buildDeps

ENTRYPOINT ["/bin/bash"]

CMD ["-l"]
