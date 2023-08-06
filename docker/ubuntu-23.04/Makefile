IMAGE_NAME = unikraft-ubuntu-23.04
CONTAINER_NAME = $(IMAGE_NAME)
LOCAL_MOUNT = $(shell pwd)/../../
DOCKER_MOUNT = /workdir

build:
	docker build -f Dockerfile -t $(IMAGE_NAME) .

run: build
	docker run -d --name $(CONTAINER_NAME) -it -v $(LOCAL_MOUNT):$(DOCKER_MOUNT) $(IMAGE_NAME) /bin/bash

enter:
	docker exec -it $(CONTAINER_NAME) /bin/bash

stop:
	-docker stop $(CONTAINER_NAME)

clean: stop
	-docker rm $(CONTAINER_NAME)

cleanimg: clean
	-docker image rm $(IMAGE_NAME)

.PHONY: build run stop clean
