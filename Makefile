NAME = zbeekman/docker-gcc-build
WORKDIR = ${HOME}/Sandbox

default: build

build:
	@docker build --build-arg VCS_REF=`git rev-parse --short HEAD` \
	--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` -t $(NAME) .

push:
	docker push $(NAME)

run:
	docker run -v $(WORKDIR):/virtual/path -i -t $(NAME)

release: build push
