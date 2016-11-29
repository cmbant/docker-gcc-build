[![Latest tag](https://images.microbadger.com/badges/version/zbeekman/docker-gcc-build.svg)](https://microbadger.com/images/zbeekman/docker-gcc-build) 
[![Last build commit](https://images.microbadger.com/badges/commit/zbeekman/docker-gcc-build.svg)](https://microbadger.com/images/zbeekman/docker-gcc-build) 
[![Docker Automated build](https://img.shields.io/docker/automated/zbeekman/docker-gcc-build.svg)](https://hub.docker.com/r/zbeekman/docker-gcc-build/builds/) 
[![Layers](https://images.microbadger.com/badges/image/zbeekman/docker-gcc-build.svg)](https://microbadger.com/images/zbeekman/docker-gcc-build)

### Overview

This is a fork of [cmbant/docker-gcc-build] that updates the docker
image with the latest GCC trunk automatically every night, using
[nightly-docker-rebuild].

This docker image is rebuilt nightly, and GCC trunk is recompiled and
included everytime the build is triggered. This should let you very
quickly grab the latest GCC trunk without having to wait to rebuild
it.

Currently gcc >= 6.1 is required to run many Fortran 2003/2008
programs successfully due to bugs in earlier versions. Also includes
standard OpenMPI and basic build tools.

Corresponding auto-built docker available at
https://registry.hub.docker.com/u/zbeekman/docker-gcc-build/

### Usage

To make an interactive shell ready for compiling you local code at
`/local/code/source` do

```
docker run -v /local/code/source:/virtual/path -i -t zbeekman/docker-gcc-build
```

Navigating into `/virtual/path` in the bash shell, you can then run `make`
etc as normal, acting on your local files.

### A note on licensing (GPL-v3)

This repository was original forked from [cmbant/docker-gcc-build]
which was licensed under GPL v2. Since there was no explicit
notification that it could only be licensed under version 2, this
repository is licensed under GPL-v3, which is consistent with the
GPL-v2 license. This license only applies to the files in this
repository: Docker, and the resulting Docker images and software they
contain are all licensed under their own licensing agreements.

```
    docker-gcc-build: Build GCC trunk from source in a Docker container
    Copyright (C) 2016  Izaak B. Beekman

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

```

### Chages

This software has been extensively modified from @cmbant's original
software, which may be obtained at [cmbant/docker-gcc-build], starting
November 2016. Some changes include, but are not limited to:

 - switch to debian:testing-slim base image login as non-root user by
   default
 - other changes made in attempt to improve utility of resultant docker
   image
 - other changes in attempt to shrink size of docker image
 - nightly automated builds on docker hub
 - image meta data on build date and commit

[cmbant/docker-gcc-build]: https://github.com/cmbant/docker-gcc-build
[nightly-docker-rebuild]: https://github.com/zbeekman/nightly-docker-rebuild
