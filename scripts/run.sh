#!/usr/bin/env bash

set -eo pipefail
set -x

#  --privileged \

docker run \
  -ti --rm \
  --name windows \
  -e USER_PASSWD='Passw0rd' \
  -e VNC_GEOMETRY=1600x900 \
  -e VNC_PASSWD='Passw0rd' \
  -p 80:80 \
  -p 22:22 \
  windows