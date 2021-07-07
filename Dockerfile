
FROM golang:1.16.5-alpine3.13 as dex

RUN apk update && apk --no-cache add git make gcc libc-dev

RUN mkdir /work
WORKDIR /work
RUN git clone https://github.com/dexidp/dex.git
WORKDIR /work/dex
RUN make && make examples

FROM alpine:3.13.5

MAINTAINER YasuhiroABE <yasu@yasundial.org>

RUN apk update && apk --no-cache add ca-certificates bash

RUN mkdir -p /dex/bin/.
COPY --from=dex /work/dex/bin/. /dex/bin/.
WORKDIR /dex
COPY run.sh /run.sh
RUN chmod +x /run.sh

## example-app listener and callback URLs
## Both connection must be routed to this service.
ENV DEXC_LISTENURL="http://0.0.0.0:5555"
ENV DEXC_REDIRECTURL="http://192.168.1.1:5555/callback"
EXPOSE 5555
## DEX Service URL
ENV DEXC_ISSUERURL="http://192.168.1.2:5556/dex"
## CLIENT INFO
ENV DEXC_CLIENT_ID="example-app"
ENV DEXC_CLIENT_SECRET="ZXhhbXBsZS1hcHAtc2VjcmV0"

RUN addgroup dexuser
RUN adduser -S -G dexuser dexuser
USER dexuser

ENTRYPOINT ["/run.sh"]
