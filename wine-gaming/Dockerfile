FROM archlinux

RUN echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

RUN pacman --noconfirm --needed -Syyu wine-nine wine-mono wine-gecko winetricks zenity \
    pulseaudio-alsa lib32-openal lib32-gst-plugins-base lib32-gst-plugins-good

RUN useradd -m -G storage,audio,video -s /bin/bash user

USER user

WORKDIR /home/user
