NAME = zbeekman/docker-gcc-build
WORKDIR = ${HOME}/Sandbox

default: build

build:
	@docker build --build-arg VCS_REF=$(shell git rev-parse --short HEAD) \
	--build-arg BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
	--build-arg VCS_URL=$(shell git remote get-url --push origin) -t $(NAME) . \
	| tee $(NAME)-build.log

push:
	docker push $(NAME)
	curl -X POST ${UBADGER_ENDPOINT}

run:
	docker run -v $(WORKDIR):/virtual/path -i -t $(NAME)
runclean:
	docker run --rm -v $(WORKDIR):/virtual/path -i -t $(NAME)

release: build push
