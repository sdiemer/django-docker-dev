
# pass local user uid and gid if greater than or equal 1000
USER_UID := $(shell id -u)
ifeq ($(shell expr $(USER_UID) \< 1000), 1)
	USER_UID := 1000
endif
USER_GID := $(shell id -g)
ifeq ($(shell expr $(USER_GID) \< 1000), 1)
	USER_GID := 1000
endif

DOCKER_IMAGE_NAME ?= django-docker-dev

build:
	docker build -t ${DOCKER_IMAGE_NAME} ${BUILD_ARGS} \
		--build-arg USER_UID=${USER_UID} \
		--build-arg USER_GID=${USER_GID} \
		-f Dockerfile .

rebuild:
	BUILD_ARGS="--no-cache" make build

push:
	docker push ${DOCKER_IMAGE_NAME}

shell:
	docker run --rm -ti -v ${CURDIR}:/apps --name ddd ${DOCKER_IMAGE_NAME}
