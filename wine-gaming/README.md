# wine-gaming-docker

Setup for playing directx9 games in docker with wine-nine.

## Get Started
1. `./build.sh`
2. `./create.sh`
    - You need to adjust your shared volumes before executing
3. `./start.sh`
4. `winetricks d3dx9 d3dx9_43 xact msxml6 dotnet45 vcrun2010`
5. `wine ninewinecfg` and tick "Enable Gallium Nine"
6. Play, `WINEDEBUG=-all GALLIUM_HUD=fps wine game.exe`
    - On intel gpu also use `MESA_LOADER_DRIVER_OVERRIDE=iris`

## Dev Info
### Turn network on/off for the container
`sudo sed -i 's/Networks":{"none"/Networks":{"bridge"/' /var/lib/docker/containers/$(docker ps -aqf "name=wine-gaming")*/config.v2.json && sudo systemctl restart docker`

### Overwriting the X Shared memory extension
It can help to prevent some application crashes, but just if the app is using the `XShmQueryExtension()` fnc before acctually calling the extension. (Sadly wine does not.)
```
#####################
# BUILD XNOSHM HACK #
#####################
# See: https://github.com/jessfraz/dockerfiles/issues/359#issuecomment-828714848
FROM docker.io/library/debian:buster AS docker_xnoshm

RUN apt update && apt -y install libc6-dev-i386 musl-dev libxext-dev libx11-dev gcc bash

ENV XNOSHM_SRC '\n\
\t#include <X11/Xlib.h>\n\
\t#include <sys/ipc.h>\n\
\t#include <sys/shm.h>\n\
\t#include <X11/extensions/XShm.h>\n\
\t\n\
\tBool XShmQueryExtension(Display *display) {\n\
\t  return 0;\n\
\t}'

RUN echo "$XNOSHM_SRC" | gcc -x c -shared -nostdlib -o /docker_xnoshm.so -
RUN echo "$XNOSHM_SRC" | gcc -x c -shared -nostdlib -m32 -o /docker_xnoshm_32.so -

################################################################################

FROM archlinux

#######################
# INSTALL XNOSHM HACK #
#######################
COPY --from=docker_xnoshm /docker_xnoshm.so /usr/lib/docker_xnoshm.so
COPY --from=docker_xnoshm /docker_xnoshm_32.so /usr/lib32/docker_xnoshm.so
ENV LD_PRELOAD="/usr/\$LIB/docker_xnoshm.so"
```

### Notes
- LIBGL_DEBUG=verbose glxinfo | grep libgl
- xdpyinfo | g -C 20 dri
- glxinfo | grep -i "vendor\|rendering"
- sudo nano /etc/X11/xorg.conf.d/20-amdgpu.conf
- https://linuxreviews.org/Intel_Iris
- https://holarse.de/news/wine_proton_dxvk_vkd3d_vkd3d_proton_runtime_container_bitte_was_wir_bringen_etwas_licht_ins
- https://wiki.archlinux.org/title/AMDGPU
- https://github.com/iXit/wine-nine-standalone
    - The DRI3 backend is the preferred one and has the lowest CPU and memory overhead.
- https://archive.fosdem.org/2015/schedule/event/d3d9/attachments/slides/722/export/events/attachments/d3d9/slides/722/GalliumNineStatus.pdf
- https://wiki.archlinux.org/title/Hardware_video_acceleration#ATI/AMD
- https://www.google.com/search?client=firefox-b-d&q=amdgpu%3A+os_same_file_description+couldn%27t+determine+if+two+DRM+fds+reference+the+same+file+description
