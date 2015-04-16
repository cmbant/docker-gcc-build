FROM cmbant/docker-gcc-prereq:latest

MAINTAINER Antony Lewis

RUN git clone git://gcc.gnu.org/git/gcc.git \
 && cd gcc \
 && mkdir objdir \
 && cd objdir \
# && ../configure --enable-languages=c,c++,fortran --disable-multilib \
 && ../configure --enable-languages=fortran --disable-multilib \
    --disable-bootstrap --enable-checking=release \
 && make -j"$(nproc)" \
 && sudo make install \
 && make distclean \
