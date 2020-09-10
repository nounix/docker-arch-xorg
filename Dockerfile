FROM archlinux

####################################### Base ##################################################

RUN mv /etc/pacman.conf.pacnew /etc/pacman.conf

RUN pacman -Syyu --noconfirm

RUN pacman -S --noconfirm wget pacman-contrib

# Select the fastest mirrors
RUN wget -qO - "https://www.archlinux.org/mirrorlist/?country=DE&protocol=https&ip_version=4&use_mirror_status=on" | sed 's/^#Server/Server/' | rankmirrors -n 10 - | tee /etc/pacman.d/mirrorlist

# Install some base packages
RUN pacman -Syy --noconfirm --needed base base-devel

# Generate locales and set them
RUN echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen
ENV LANG=de_DE.UTF-8

RUN pacman -S --noconfirm --needed \
    bash-completion \
    docker \
    git tk \
    htop \
    man \
    nano \
    openssh \
    ranger \
    sudo \
    tmux \
    tree \
    wget \
    zsh

# Install mesa hardware acceleration and alsa plugin for sound with pulse
RUN pacman -S --noconfirm --needed mesa-demos pulseaudio-alsa

# Install graphical programs
RUN pacman -S --noconfirm --needed chromium code dmenu

# Create man index cache
RUN mandb

# Clean up pacman
RUN pacman -Sc --noconfirm

# Configure sudo
RUN sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

# Configure dmenu_path
RUN sed -i 's/dmenu_run/dmenu_run_docker/' /usr/sbin/dmenu_path

ARG USER

# Add user to docker group and kmem for docker socket
RUN useradd -m -G wheel,storage,audio,video,docker,kmem -s /usr/bin/zsh $USER

####################################### Optional ##################################################

# Install yay AUR helper
# RUN wget "https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz" -O - | tar xz -C /tmp/
# RUN chown -R $USER:$USER /tmp/yay/
# RUN sudo -u $USER bash -c 'cd /tmp/yay && makepkg -s'
# RUN pacman -U --noconfirm /tmp/yay/yay*.pkg.tar.xz

# Install dotnet core sdk 3.1
# RUN mkdir /opt/dotnet/
# RUN wget "https://download.visualstudio.microsoft.com/download/pr/d731f991-8e68-4c7c-8ea0-fad5605b077a/49497b5420eecbd905158d86d738af64/dotnet-sdk-3.1.100-linux-x64.tar.gz" -O - | tar xz -C /opt/dotnet/
# RUN ln -s /opt/dotnet/dotnet /usr/bin/dotnet
# ENV DOTNET_ROOT=/opt/dotnet/

# Install rider jetbrains ide
# RUN mkdir /opt/rider/
# RUN wget "https://download.jetbrains.com/rider/JetBrains.Rider-2019.3.tar.gz" -O - | tar xz -C /opt/rider/ --strip 1
# RUN ln -s /opt/rider/bin/rider.sh /usr/bin/rider

# Install golang
# RUN pacman -S --noconfirm --needed go go-tools
# ENV GOPATH=/home/$USER/dev/go
# ENV GOBIN=$GOPATH/bin

####################################### End ##################################################

# Update arch
ARG DISABLE_CACHE=1
RUN pacman --noconfirm -Syyu

# Set user
ENV USER=$USER
USER $USER

WORKDIR /home/$USER

####################################### TODO ##################################################
# jdk8-openjdk
# libxslt
# dotnet turn off telemetry
# more intelligent image updating
