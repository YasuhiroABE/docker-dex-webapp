
DOCKER_CMD = podman

NAME = dex-webapp
DOCKER_IMAGE = dex-webapp
DOCKER_IMAGE_VERSION = 20240827.1600
IMAGE_NAME = $(DOCKER_IMAGE):$(DOCKER_IMAGE_VERSION)

REGISTRY_SERVER = docker.io
REGISTRY_LIBRARY = yasuhiroabe
PROD_IMAGE_NAME = $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME)

DEXC_REDIRECTURL="http://192.168.1.1:5555/callback"
DEXC_ISSUERURL="http://192.168.1.2:5556/dex"

.PHONY: all
all:
	@echo "Please specify a target: make [run|docker-build|docker-build-prod|docker-push|docker-run|docker-stop|check|clean]"

.PHONY: run
run: bundle-install
	env FORM_BASEURI="$(PROTOCOL)://$(HOST):$(PORT)/$(URI_PATH)" \
		bundle exec rackup --host $(HOST) --port $(PORT)

.PHONY: bundle-install
bundle-install:
	bundle config set path lib
	bundle install

.PHONY: docker-build
docker-build:
	$(DOCKER_CMD) build . --pull --tag $(DOCKER_IMAGE):latest

.PHONY: docker-build-prod
docker-build-prod:
	$(DOCKER_CMD) build . --pull --tag $(IMAGE_NAME) --no-cache

.PHONY: docker-tag
docker-tag:
	$(DOCKER_CMD) tag $(IMAGE_NAME) $(PROD_IMAGE_NAME)

.PHONY: docker-push
docker-push:
	$(DOCKER_CMD) push $(PROD_IMAGE_NAME)

.PHONY: docker-run-server
docker-run-server:
	$(DOCKER_CMD) run -it --rm \
		-p 5556:5556 \
		--volume $(PWD)/server/run.sh:/run.sh \
		--volume $(PWD)/server/config-ldap-prod.yaml:/config/config-ldap-prod.yaml \
		--env CONFIG_FILEPATH="/config/config-ldap-prod.yaml" \
		--name $(NAME) \
		$(DOCKER_IMAGE):latest

.PHONY: docker-run
docker-run:
	$(DOCKER_CMD) run -it --rm \
		-p 8000:5555 \
		--env DEXC_REDIRECTURL=$(DEXC_REDIRECTURL) \
		--env DEXC_ISSUERURL=$(DEXC_ISSUERURL) \
		--name $(NAME) \
		$(DOCKER_IMAGE):latest

.PHONY: docker-stop
docker-stop:
	$(DOCKER_CMD) stop $(NAME)

.PHONY: clean
clean:
	find . -name '*~' -type f -exec rm {} \; -print
