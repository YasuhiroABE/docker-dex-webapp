

TARGET_DOCKER = "yasuhiroabe/dex-webapp"

.PHONY: all build run ps check

all:
	@echo "please specify a target: make [build|run|ps|check]"

build:
	sudo docker build . --tag $(TARGET_DOCKER)

run:
	@echo "Before execting, please ensure running the dex server on 10.1.1.1:5556."
	sudo docker run -it --rm \
		--env DEXC_LISTENURL="http://0.0.0.0:5555" \
		--env DEXC_REDIRECTURL="http://localhost:8000/callback" \
		--env DEXC_ISSUERURL="http://10.1.1.1:5556/dex" \
		-p 8000:5555 \
                $(TARGET_DOCKER)

push:
	sudo docker push $(TARGET_DOCKER):latest

ps:
	sudo docker ps

check:
	sudo docker images | grep $(TARGET_DOCKER)
