FROM debian:testing-slim

MAINTAINER Izaak "Zaak" Beekman <contact@izaakbeekman.com>

ENV REFRESHED_AT 2016-11-22

RUN  apt-get update && apt-get install --no-install-recommends -y \
     texinfo \
     ca-certificates \
     build-essential \
     cmake \
     cmake-curses-gui \
     git \
     openmpi-bin \
     libopenmpi-dev \     
 && apt-get clean

# Build-time metadata as defined at http://label-schema.org
    ARG BUILD_DATE
    ARG VCS_REF
    LABEL org.label-schema.build-date=$BUILD_DATE \
          org.label-schema.name="docker-gcc-build" \
          org.label-schema.description="Nightly builds of GCC trunk using docker" \
          org.label-schema.url="https://github.com/zbeekman/docker-gcc-build/" \
          org.label-schema.vcs-ref=$VCS_REF \
          org.label-schema.vcs-url="https://github.com/zbeekman/docker-gcc-build" \
          org.label-schema.vendor="zbeekman" \
          org.label-schema.license="GPL-2.0" \
          org.label-schema.schema-version="1.0"

RUN buildDeps='bison flex libmpc-dev g++ ' \
 && apt-get update && apt-get install -y $buildDeps libisl-dev --no-install-recommends \
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
