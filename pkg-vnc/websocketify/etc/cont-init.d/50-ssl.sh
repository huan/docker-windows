#!/usr/bin/with-contenv /bin/bash

set -eo pipefail

[[ $DEBUG == true ]] && set -x

PEM_FILE=novnc.pem

pushd /etc/ssl
echo -e '\n\n\n\n\n\n\n\n\n' | \
    openssl req -x509 -nodes -newkey rsa:2048 -keyout "$PEM_FILE" -out "$PEM_FILE" -days 3650
popd