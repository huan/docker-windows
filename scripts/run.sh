#!/usr/bin/env bash

set -eo pipefail
set -x

docker run \
  -ti --rm \
  -e USER_PASSWD='Passw0rd' \
  -e VNC_GEOMETRY=1400x720 \
  -e VNC_PASSWD='Passw0rd' \
  -p 80:80 \
  -p 22:22 \
  windows