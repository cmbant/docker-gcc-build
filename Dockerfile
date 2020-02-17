FROM sourceryinstitute/docker-base:latest

RUN DEBIAN_FRONTEND=noninteractive transientBuildDeps="dpkg-dev apt-utils bison flex libmpc-dev" \
    && set -v \
    && echo "$DEBIAN_FRONTEND" "$transientBuildDeps" \
    && apt-get update \
    && apt-get install -y $transientBuildDeps libisl-dev liblapack-dev libopenblas-dev openmpi-bin libopenmpi-dev --no-install-recommends --no-install-suggests \
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
    && dpkg-divert --divert /usr/bin/gcc.orig --rename /usr/bin/gcc \
    && dpkg-divert --divert /usr/bin/g++.orig --rename /usr/bin/g++ \
    && dpkg-divert --divert /usr/bin/gfortran.orig --rename /usr/bin/gfortran \
    && update-alternatives --install /usr/bin/cc cc /usr/local/bin/gcc 999 \
    && apt-get purge -y --auto-remove $transientBuildDeps \
    && rm -rf /var/lib/apt/lists/* /var/log/* /tmp/*


