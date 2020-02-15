#!/usr/bin/env bash

set -eo pipefail
set -x

docker run \
  -ti --rm \
  -e VNC_GEOMETRY=1400x720 \
  -e USER_PASSWD='Passw0rd' \
  -p 80:80 \
  windows