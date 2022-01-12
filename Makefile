SYMFONY_MAX_DEPRECATED ?= 500
SSH_PATH ?= ~/.ssh/id_rsa

export FPM_UID = $(shell id -u)
export FPM_GID = $(shell id -g)

DOCKER = docker

PHP_BUILD      = $(DOCKER_COMPOSE) run --rm --user="$(shell id -u):$(shell id -g)" build-php
CONSOLE        = $(PHP_BUILD) php bin/console


buildx-build:
	@docker buildx build --tag ghcr.io/adefilippi/build-php7.1:latest --file ./Dockerfile-build ./

buildx-push-build:
	@docker buildx build --tag ghcr.io/adefilippi/build-php7.1:latest --file ./Dockerfile-build --push ./

buildx-fpm:
	@docker buildx build --tag ghcr.io/adefilippi/build-php7.1:latest --file ./Dockerfile-fpm ./

buildx-push-fpm:
	@docker buildx build --tag ghcr.io/adefilippi/build-php7.1:latest --file ./Dockerfile-fpm ./
