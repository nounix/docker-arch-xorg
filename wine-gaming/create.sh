#!/bin/bash

PULSE_DIR="$XDG_RUNTIME_DIR/pulse/native"

# Add "--ipc=host" if you dont care about security and to avoid the X shared memory crash.
# Add "--device /dev/input" if you want to use devices like controllers etc.

docker create -it \
    --name wine-gaming \
    --net=none \
    --device /dev/dri:/dev/dri \
    --shm-size=2gb \
    --init \
    -e DISPLAY \
    -e PULSE_SERVER=unix:$PULSE_DIR \
    -v $PULSE_DIR:$PULSE_DIR \
	-v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 \
	-v $HOME/.Xauthority:/home/user/.Xauthority \
	-v $HOME/games/:/home/user/games/ \
    wine-gaming bash
