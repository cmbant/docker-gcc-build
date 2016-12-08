FROM debian:testing-slim

MAINTAINER Izaak "Zaak" Beekman <contact@izaakbeekman.com>

ENV REFRESHED_AT 2016-12-07
COPY NOTICE /NOTICE

RUN  DEBIAN_FRONTEND=noninteractive \
     && set -v \
     && echo "$DEBIAN_FRONTEND" \
     && cat /NOTICE \
     && apt-get update \
     && apt-get install --no-install-recommends --no-install-suggests -y \
	  autoconf \
	  automake \
	  ca-certificates \
	  cmake \
	  curl \
	  file \
	  g++ \
	  gcc \
	  gfortran \
	  git \
	  libopenmpi-dev \
	  libtool \
	  make \
	  openmpi-bin \
	  openssh-client \
	  openssh-server \
	  patch \
	  procps \
	  wget \
     && apt-get autoremove \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/* /var/log/* /tmp/* \
     && useradd -m --system -s /sbin/nologin sourcerer \
     && echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/issue && cat /etc/motd && cat /NOTICE' >> /etc/bash.bashrc \
     && printf "\
         nightly-gcc-trunk-docker-image  Copyright (C) 2016  Izaak B. Beekman\n\
	 This program comes with ABSOLUTELY NO WARRANTY.\n\
	 This is free software, and you are welcome to redistribute it\n\
	 under certain conditions.\n\
	 \n\
	 see https://github.com/zbeekman/nightly-gcc-trunk-docker-image/blob/master/LICENSE for the full GPL-v3 license\n" > /etc/motd


# Build-time metadata as defined at http://label-schema.org
    ARG BUILD_DATE
    ARG VCS_REF
    ARG VCS_URL
    LABEL org.label-schema.schema-version="1.0" \
    	  org.label-schema.build-date="$BUILD_DATE" \
          org.label-schema.name="nightly-gcc-trunk-docker-image" \
          org.label-schema.description="Nightly builds of GCC trunk using docker" \
          org.label-schema.url="https://github.com/zbeekman/nightly-gcc-trunk-docker-image/" \
          org.label-schema.vcs-ref="$VCS_REF" \
          org.label-schema.vcs-url="$VCS_URL" \
          org.label-schema.vendor="zbeekman" \
          org.label-schema.license="GPL-3.0" \
          org.label-schema.docker.cmd="docker run -v $(pwd):/virtual/path -i -t zbeekman/nightly-gcc-trunk-docker-image"



RUN DEBIAN_FRONTEND=noninteractive transientBuildDeps="bison flex libmpc-dev g++" \
    && set -v \
    && echo "$DEBIAN_FRONTEND" "$transientBuildDeps" \
    && apt-get update \
    && apt-get install -y $transientBuildDeps libisl-dev --no-install-recommends --no-install-suggests \
    && git clone --depth=1 --single-branch --branch master git://gcc.gnu.org/git/gcc.git gcc \
    && cd gcc \
    && mkdir objdir \
    && cd objdir \
    && ../configure --enable-languages=c,c++,fortran --disable-multilib \
       --disable-bootstrap --build=x86_64-linux-gnu \
    && make -j"$(nproc)" \
    && make install-strip \
    && make distclean \
    && cd ../.. \
    && rm -rf ./gcc \
    && echo '/usr/local/lib64' > /etc/ld.so.conf.d/local-lib64.conf \
    && ldconfig -v\
    && apt-get purge -y --auto-remove $transientBuildDeps \
    && dpkg-divert --divert /usr/bin/gcc.orig --rename /usr/bin/gcc \
    && dpkg-divert --divert /usr/bin/g++.orig --rename /usr/bin/g++ \
    && dpkg-divert --divert /usr/bin/gfortran.orig --rename /usr/bin/gfortran \
    && update-alternatives --install /usr/bin/cc cc /usr/local/bin/gcc 999 \
    && rm -rf /var/lib/apt/lists/* /var/log/* /tmp/*

USER sourcerer

ENTRYPOINT ["/bin/bash"]

CMD ["-l"]
