#!/usr/bin/with-contenv /bin/bash

set -eo pipefail

[[ $DEBUG == true ]] && set -x

echo "user:$USER_PASSWD" | chpasswd
