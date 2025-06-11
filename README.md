### Overview

This repository has the Dockerfile for source build of gcc and gfortran. 

Corresponding auto-build docker available at
https://registry.hub.docker.com/u/cmbant/docker-gcc-build/

### Usage

To make an interactive shell ready for compiling you local code at /local/code/source
do

    docker run -v /local/code/source:/virtual/path -i -t cmbant/docker-gcc-build:gcc15 /bin/bash

Navigating into /virtual/path in the bash shell, you can then run make etc as normal, acting
on your local files.
