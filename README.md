### Overview

This repository has the Dockerfile for source build of gcc 6 (experimental).

Currently gcc 6 is required to run many Fortran 2003/2008 programs successfully due
to bugs in earlier versions. Also includes standard openmpi and lapack libraries,
plus basic build tools.

Corresponding auto-build docker available at
https://registry.hub.docker.com/u/cmbant/docker-gcc-build/

### Usage

To make an interactive shell ready for compiling you local code at /local/code/source
do

    docker run -v /local/code/source:/virtual/path -i -t cmbant/docker-gcc-build /bin/bash

Navigating into /virtual/path in the bash shell, you can then run make etc as normal, acting
on your local files.