
FROM ubuntu:18.04

MAINTAINER YasuhiroABE <yasu@yasundial.org>

ADD etc.resolv.conf /etc/resolv.conf
ENV GOPATH /root/go

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    golang-go git ca-certificates make build-essential

RUN go get github.com/dexidp/dex || true
WORKDIR /root/go/src/github.com/dexidp/dex

RUN make
COPY run.sh /run.sh
RUN chmod +x /run.sh

## example-app listener and callback URLs
## Both connection must be routed to this service.
ENV DEXC_LISTENURL="http://0.0.0.0:5555"
ENV DEXC_REDIRECTURL="http://192.168.1.1:5555/callback"
EXPOSE 5555
## DEX Service URL
ENV DEXC_ISSUERURL="http://192.168.1.2:5556/dex"

ENTRYPOINT ["/run.sh"]


