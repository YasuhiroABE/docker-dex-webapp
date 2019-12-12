#!/bin/bash -x

cd /dex
exec bin/example-app  \
    --client-id "${DEXC_CLIENT_ID}" \
    --client-secret "${DEXC_CLIENT_SECRET}" \
    --listen "${DEXC_LISTENURL}" \
    --redirect-uri "${DEXC_REDIRECTURL}" \
    --issuer "${DEXC_ISSUERURL}"


