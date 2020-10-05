
FROM golang:alpine3.12 as dex

RUN apk --no-cache add git make gcc libc-dev

ENV GOPATH /root/go
RUN go get github.com/dexidp/dex || true
WORKDIR /root/go/src/github.com/dexidp/dex
RUN make build examples

FROM alpine:latest

MAINTAINER YasuhiroABE <yasu@yasundial.org>

RUN apk --no-cache add ca-certificates
RUN apk --no-cache add bash

COPY --from=dex /root/go/src/github.com/dexidp/dex /dex
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

ENTRYPOINT ["/run.sh"]
