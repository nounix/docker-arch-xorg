#!/bin/bash

DBUS_DIR="$(echo $DBUS_SESSION_BUS_ADDRESS | cut -d '=' -f 2)"
PULSE_DIR="$XDG_RUNTIME_DIR/pulse/native"

# --privileged --net=host --pid=host --uts=host --ipc=host \
# -e DBUS_SESSION_BUS_ADDRESS \
# -v $DBUS_DIR:$DBUS_DIR:ro \

docker create -it \
	--name arch-dev \
    --net=host \
    --device /dev/dri:/dev/dri \
    --shm-size=2gb \
    --init \
    -e PATH \
    -e SHELL \
    -e VISUAL \
    -e EDITOR \
    -e SUDO_ASKPASS \
    -e DISPLAY \
    -e PULSE_SERVER=unix:$PULSE_DIR \
    -v $PULSE_DIR:$PULSE_DIR:ro \
    -v /etc/localtime:/etc/localtime:ro \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0:ro \
    -v $HOME/.Xauthority:$HOME/.Xauthority:ro \
    -v $HOME/dev:$HOME/dev:ro \
    arch-dev zsh
