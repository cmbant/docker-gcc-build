### Overview

This repository has the Dockerfile for source build of gcc 15 with gfortran.

Also includes standard openmpi and lapack libraries, valgrind, and basic build tools.

The devel branch has the latest master build (at time of Docker build).

Corresponding auto-build docker available at
https://registry.hub.docker.com/u/cmbant/docker-gcc-build/

### Usage

To make an interactive shell ready for compiling you local code at /local/code/source
do

    docker run -v /local/code/source:/virtual/path -i -t cmbant/docker-gcc-build /bin/bash

Navigating into /virtual/path in the bash shell, you can then run make etc as normal, acting
on your local files.
