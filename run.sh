#!/bin/bash -x

cd /root/go/src/github.com/dexidp/dex

exec bin/example-app  \
    --listen "${DEXC_LISTENURL}" \
    --redirect-uri "${DEXC_REDIRECTURL}" \
    --issuer "${DEXC_ISSUERURL}"


