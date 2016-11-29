FROM debian:testing-slim

MAINTAINER Izaak "Zaak" Beekman <contact@izaakbeekman.com>

ENV REFRESHED_AT 2016-11-28

COPY NOTICE /NOTICE

RUN  cat /NOTICE \
     && apt-get update \
     && apt-get install --no-install-recommends --no-install-suggests -y \
     ca-certificates \
     build-essential \
     cmake \
     git \
     openmpi-bin \
     libopenmpi-dev \
     openssh-client \
     openssh-server \
 && apt-get autoremove \
 && apt-get clean \
 && useradd --system -s /sbin/nologin sourcerer \
 && echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/issue && cat /etc/motd && cat /NOTICE' >> /etc/bash.bashrc \
 ; echo "\
    docker-gcc-build  Copyright (C) 2016  Izaak B. Beekman\n\
    This program comes with ABSOLUTELY NO WARRANTY.\n\
    This is free software, and you are welcome to redistribute it\n\
    under certain conditions.\n\
    \n\
    see https://github.com/zbeekman/docker-gcc-build/blob/master/LICENSE for the full GPL-v3 license\n" > /etc/motd


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
          org.label-schema.license="GPL-3.0" \
          org.label-schema.docker.cmd="docker run -v /local/code/source:/virtual/path -i -t zbeekman/docker-gcc-build" \
          org.label-schema.schema-version="1.0"

ENV transientBuildDeps subversion git-svn bison flex libmpc-dev g++

RUN apt-get update && apt-get install -y $transientBuildDeps libisl-dev --no-install-recommends --no-install-suggests \
 && git svn clone --no-minimize-url --ignore-paths="^[^/]+/(?:branches|tags)" --preserve-empty-dirs --localtime -s -rHEAD svn://gcc.gnu.org/svn/gcc/ \
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
 && apt-get purge -y --auto-remove $transientBuildDeps

USER sourcerer

ENTRYPOINT ["/bin/bash"]

CMD ["-l"]
