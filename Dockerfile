FROM ubuntu:devel

MAINTAINER Antony Lewis

RUN apt-get update && apt-get install -y \
     build-essential \
     git \
     liblapack-dev \
     libopenblas-dev \
     openmpi-bin \
     libopenmpi-dev \
 && apt-get clean

