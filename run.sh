#!/bin/bash

xauth-any-host() {
    xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth nmerge -
}

fonts=/usr/share/fonts/
fonts_conf=/etc/fonts/
themes=/usr/share/themes/
icons=/usr/share/icons/
dbus="$(echo $DBUS_SESSION_BUS_ADDRESS | cut -d '=' -f 2)"
pulse="$XDG_RUNTIME_DIR/pulse/native"

docker run -d -i --rm --name arch-dev --privileged --net=host --pid=host --uts=host --ipc=host \
    -e PATH \
    -e SHELL \
    -e VISUAL \
    -e EDITOR \
    -e SUDO_ASKPASS \
    -e DISPLAY \
    -e DBUS_SESSION_BUS_ADDRESS \
    -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
    -v /dev/:/dev/ \
    -v $dbus:$dbus \
    -v $pulse:$pulse \
    -v $fonts:$fonts \
    -v $fonts_conf:$fonts_conf \
    -v $themes:$themes \
    -v $icons:$icons \
    -v $HOME/:$HOME/ \
    -v /etc/localtime:/etc/localtime:ro \
    -v /etc/shadow:/etc/shadow:ro \
    -v /var/run/docker.sock:/var/run/docker.sock \
    arch-dev sh
