

TARGET_DOCKER = "yasuhiroabe/dex-webapp"

.PHONY: all build run ps check

all:
	@echo "please specify a target: make [build|run|ps|check]"

build:
	sudo docker build . --tag $(TARGET_DOCKER)

run:
	sudo docker run -it --rm \
		--env DEXC_LISTENURL="http://0.0.0.0:5555" \
		--env DEXC_REDIRECTURL="http://127.0.0.1:5555/callback" \
		--env DEXC_ISSUERURL="http://10.1.1.1:5556/dex" \
		-p 5555:5555 \
                $(TARGET_DOCKER)

bg:
	sudo docker run -d --rm \
		--env DEXC_LISTENURL="http://0.0.0.0:5555" \
		--env DEXC_REDIRECTURL="http://127.0.0.1:5555/callback" \
		--env DEXC_ISSUERURL="https://opm00h.u-aizu.ac.jp/dex" \
		-p 5555:5555 \
                $(TARGET_DOCKER)

push:
	sudo docker push $(TARGET_DOCKER):latest

ps:
	sudo docker ps

check:
	sudo docker images | grep $(TARGET_DOCKER)
