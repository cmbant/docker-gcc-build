### Overview

This is an experimental fork of [cmbant/docker-gcc-build](https://github.com/cmbant/docker-gcc-build)
This repository has the Dockerfile for source build of gcc 7 (experimental).

Currently gcc 7 is required to run many Fortran 2003/2008 programs successfully due
to bugs in earlier versions. Also includes standard mpich and basic build tools.

Corresponding auto-build docker available at
https://registry.hub.docker.com/u/zbeekman/docker-gcc-build/

### Usage

To make an interactive shell ready for compiling you local code at /local/code/source
do

    docker run -v /local/code/source:/virtual/path -i -t zbeekman/docker-gcc-build /bin/bash

Navigating into /virtual/path in the bash shell, you can then run make etc as normal, acting
on your local files.