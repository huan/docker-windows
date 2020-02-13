#!/usr/bin/with-contenv /bin/bash

set -eo pipefail

[[ $DEBUG == true ]] && set -x

echo -e "$VNC_PASSWD\n$VNC_PASSWD\n\n" | sudo -Hu user vncpasswd

if [ -f /tmp/.X11-lock ]; then
    rm -f /tmp/.X11-lock
fi
