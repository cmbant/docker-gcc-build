FROM cmbant/docker-gcc-prereq:latest

MAINTAINER Antony Lewis

RUN apt-get install -y liblapack-dev openmpi-bin libopenmpi-dev 

ADD https://gcc.gnu.org/git/?p=gcc.git;a=shortlog;h=refs/heads/vehre/head_cosmo gcc_shortlog

RUN git clone git://gcc.gnu.org/git/gcc.git --branch vehre/head_cosmo --single-branch \
 && cd gcc \
 && mkdir objdir \
 && cd objdir \
 && ../configure --enable-languages=c,c++,fortran --disable-multilib \
    --disable-bootstrap --enable-checking=release --build=x86_64-linux-gnu \
 && make -j"$(nproc)" \
 && sudo make install \
 && make distclean \
 && sed -i '1s/^/\/usr\/local\/lib64\n/' /etc/ld.so.conf
