FROM debian:stable-slim

MAINTAINER Antony Lewis

ARG BUILD_DATE
ARG IMAGE_NAME
ARG SOURCE_BRANCH
ARG SOURCE_COMMIT

ARG GCC_BRANCH=releases/gcc-15

ADD https://gcc.gnu.org/git/?p=gcc.git;a=shortlog;h=refs/heads/$GCC_BRANCH gcc_shortlog

LABEL org.label-schema.schema-version="1.0" \
	  org.label-schema.build-date="$BUILD_DATE" \
      org.label-schema.name="docker-gcc-build" \
      org.label-schema.description="GCC and gfortran source $GCC_BRANCH build ($BUILD_DATE)" \
      org.label-schema.url="https://github.com/cmbant/docker-gcc-build/tree/$SOURCE_BRANCH" \
      org.label-schema.version="$SOURCE_COMMIT" \
      org.label-schema.vendor="cmbant" \
      org.label-schema.license="GPL-3.0" \
      org.label-schema.docker.cmd="docker run -v $(pwd):/virtual/path -i -t $IMAGE_NAME /bin/bash"


RUN DEBIAN_FRONTEND=noninteractive transientBuildDeps="dpkg-dev apt-utils bison flex libmpc-dev" \
    && set -v \
    && echo "$DEBIAN_FRONTEND" "$transientBuildDeps" \
    && apt-get update \
    && apt-get install -y $transientBuildDeps \
       build-essential git wget sudo cmake libtool ca-certificates openssh-client gcc g++ \
       libisl-dev liblapack-dev libopenblas-dev openmpi-bin libopenmpi-dev \
       --no-install-recommends --no-install-suggests \
    && git clone --depth=1 --single-branch --branch $GCC_BRANCH git://gcc.gnu.org/git/gcc.git gcc \
    && cd gcc \
    && mkdir objdir \
    && cd objdir \
    && ../configure --enable-languages=c,c++,fortran --disable-multilib \
       --disable-bootstrap --build=x86_64-linux-gnu \
    && make -j"$(nproc)" \
    && make install-strip \
    && make distclean || true \
    && cd ../.. \
    && rm -rf ./gcc \
    && echo '/usr/local/lib64' > /etc/ld.so.conf.d/local-lib64.conf \
    && ldconfig -v\
    && dpkg-divert --divert /usr/bin/gcc.orig --rename /usr/bin/gcc \
    && dpkg-divert --divert /usr/bin/g++.orig --rename /usr/bin/g++ \
    && update-alternatives --install /usr/bin/cc cc /usr/local/bin/gcc 999 \
    && apt-get purge -y --auto-remove $transientBuildDeps \
    && apt-get install -y build-essential valgrind \
    && rm -rf /var/lib/apt/lists/* /var/log/* /tmp/*


#Match conventions to the other cmbant gcc images (gcc6, gcc7 etc)
ENTRYPOINT []
CMD []
