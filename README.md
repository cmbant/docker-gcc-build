[![Latest tag](https://images.microbadger.com/badges/version/zbeekman/docker-gcc-build.svg)](https://microbadger.com/images/zbeekman/docker-gcc-build) 
[![Last build commit](https://images.microbadger.com/badges/commit/zbeekman/docker-gcc-build.svg)](https://microbadger.com/images/zbeekman/docker-gcc-build) 
[![Docker Automated build](https://img.shields.io/docker/automated/zbeekman/docker-gcc-build.svg)](https://hub.docker.com/r/zbeekman/docker-gcc-build/builds/) 
[![Layers](https://images.microbadger.com/badges/image/zbeekman/docker-gcc-build.svg)](https://microbadger.com/images/zbeekman/docker-gcc-build)

### Overview

This is a fork of [cmbant/docker-gcc-build](https://github.com/cmbant/docker-gcc-build) that
updates the docker image with the latest GCC trunk automatically every night.

This docker image is rebuilt nightly, and GCC trunk is recompiled and included everytime the build
is triggered. This should let you very quickly grab the latest GCC trunk without having to wait to
rebuild it.

Currently gcc >= 6.1 is required to run many Fortran 2003/2008 programs successfully due
to bugs in earlier versions. Also includes standard mpich and basic build tools.

Corresponding auto-build docker available at
https://registry.hub.docker.com/u/zbeekman/docker-gcc-build/

### Usage

To make an interactive shell ready for compiling you local code at /local/code/source
do

    docker run -v /local/code/source:/virtual/path -i -t zbeekman/docker-gcc-build /bin/bash

Navigating into /virtual/path in the bash shell, you can then run make etc as normal, acting
on your local files.