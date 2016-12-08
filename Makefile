NAME = zbeekman/nightly-gcc-trunk-docker-image
WORKDIR = ${HOME}/Sandbox

default: build

build:
	@hooks/build 2>&1 | tee $(subst /,_,$(NAME))-build.log

push:
	docker push $(NAME)
	curl -X POST ${UBADGER_ENDPOINT}

run:
	docker run -v $(WORKDIR):/virtual/path -i -t $(NAME)
runclean:
	docker run --rm -v $(WORKDIR):/virtual/path -i -t $(NAME)

release: build push
