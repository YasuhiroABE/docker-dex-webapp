FROM docker.io/library/golang:1.22-alpine as dex
ARG DEX_TAGNAME=v2.39.1

RUN apk --no-cache add git make gcc libc-dev patch

RUN mkdir /work
WORKDIR /work
RUN git clone --depth 1 --branch $DEX_TAGNAME https://github.com/dexidp/dex.git

WORKDIR /work/dex
##COPY image/logo.png web/themes/dark/logo.png
##COPY image/logo.png web/themes/light/logo.png
COPY patch/20240523-v2.39.1.patch /v2.39.1.patch
RUN patch -p1 < /v2.39.1.patch
RUN make build && make examples

FROM docker.io/library/alpine:3.19

MAINTAINER YasuhiroABE <yasu-abe@u-aizu.ac.jp>

RUN apk update && apk add --no-cache bash ca-certificates

RUN mkdir -p /dex/bin
COPY --from=dex /work/dex/bin/. /dex/bin/.
COPY run.sh /run.sh
RUN chmod +x /run.sh

WORKDIR /dex

## Server Settings
EXPOSE 5556
ENV DEX_CONFIG_TEMPLPATH="/config/config-ldap.yaml.templ"
ENV DEX_ISSUER="http://127.0.0.1:5556/dex "
ENV DEX_APP01_REDIRECTURI="http://example.app:5555/callback"

## Client Settings
EXPOSE 5555
ENV DEXC_LISTENURL="http://0.0.0.0:5555"
ENV DEXC_REDIRECTURL="http://192.168.1.1:5555/callback"
ENV DEXC_ISSUERURL="http://192.168.1.2:5556/dex"
ENV DEXC_CLIENT_ID="example-app"
ENV DEXC_CLIENT_SECRET="ZXhhbXBsZS1hcHAtc2VjcmV0"

RUN mkdir /config /data
VOLUME ["/config", "/data"]

ENTRYPOINT ["/run.sh"]
