
#
# Stage 1: VNC
#
FROM ubuntu:bionic as VNC

ARG DEBIAN_FRONTEND=noninteractive
ARG S6_OVERLAY_VERSION=1.22.1.0
ARG S6_OVERLAY_MD5HASH=3060e2fdd92741ce38928150c0c0346a

ENV DISPLAY=:0 \
  LANG='C.UTF-8' \
  LC_ALL='C.UTF-8' \
  S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
  USER_PASSWD=Passw0rd \
  VNC_DEPTH=16 \
  VNC_GEOMETRY=1600x900 \
  VNC_PASSWD=Passw0rd \
  WINEDEBUG=-all

RUN apt-get update \
  && apt-get install -y \
    \
      novnc \
      openbox \
      tigervnc-standalone-server \
      websockify \
      xterm \
    \
      git \
      openssh-client \
      openssh-server \
      vim \
    \
    apt-transport-https \
    ca-certificates \
    curl \
    python-numpy \
    software-properties-common \
    sudo \
    tzdata \
    wget \
    xorg \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -fr /tmp/*

# S6 Overlay
RUN curl -J -L -o /tmp/s6-overlay-amd64.tar.gz "https://github.com/just-containers/s6-overlay/releases/download/v$S6_OVERLAY_VERSION/s6-overlay-amd64.tar.gz" \
   && echo -n "Checking md5sum... " \
   && echo "$S6_OVERLAY_MD5HASH /tmp/s6-overlay-amd64.tar.gz" | md5sum -c - \
   && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
   && rm /tmp/s6-overlay-amd64.tar.gz

ENTRYPOINT '/init'

RUN groupadd group \
  && useradd -m -g group user \
  && chsh -s /bin/bash user \
  && echo 'user ALL=(ALL:ALL) ALL' >> /etc/sudoers

# WebSocketify & novnc
EXPOSE 80/tcp
# TigerVNC
EXPOSE 5900/tcp

COPY ./pkg-vnc/* /
# RUN chown -R user:group /home/user

#
# Stage 2: Wine
#

FROM VNC

RUN curl -sL https://dl.winehq.org/wine-builds/winehq.key | apt-key add - \
  && apt-add-repository -y https://dl.winehq.org/wine-builds/ubuntu \
  && dpkg --add-architecture i386 \
  && echo 'WineHQ Repository added'

RUN curl -sL https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/Release.key | apt-key add - \
  && sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./' \
  && echo 'Wine: Libfaudio Repository added '

RUN apt-get install --install-recommends -y \
    winehq-stable \
    winetricks \
    \
    wine-stable \
    wine-stable-i386 \
    wine-stable-amd64 \
    libfaudio0:i386 \
    cabextract \
    unzip \
    language-pack-zh-hans \
    ttf-wqy-microhei \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists

# RUN curl -sL -o /usr/local/bin/winetricks https://github.com/Winetricks/winetricks/raw/master/src/winetricks \
#   && chmod 755 /usr/local/bin/winetricks \
#   && curl -sL -o /usr/share/bash-completion/completions/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks.bash-completion \
#   && echo "Wine: winetricks installed"

ARG LUNA_DIR=/home/user/.wine/drive_c/windows/Resources/Themes/luna/
ARG LUNA_URL=https://github.com/huan/docker-windows/releases/download/v0.1/luna.msstyles.gz
RUN mkdir -p $LUNA_DIR \
  && curl -sL $LUNA_URL | gzip -d > "$LUNA_DIR/luna.msstyles" \
  && echo 'Theme: luna.msstyles installed'

ARG FONTS_DIR=/home/user/.wine/drive_c/windows/Fonts/
ARG SIMSUN_URL=https://github.com/huan/docker-windows/releases/download/v0.1/simsun.ttc.gz
RUN mkdir -p $FONTS_DIR \
  && curl -sL $SIMSUN_URL | gzip -d > "$FONTS_DIR/simsun.ttc" \
  && echo "Fonts: simsun.ttc installed"

COPY ./pkg-wine/* /
RUN chown -R user:group /home/user

# vcrun6
# winetricks vcrun2013
# winetricks vcrun2015
# winetricks vcrun2017
  # && su user -c 'winetricks -q corefonts' \

# winetricks dbghelp
# winetricks wininet # WinHttpGetIEProxyConfigForCurrentUser failed

RUN su user -c 'WINEARCH=win32 /usr/bin/wine wineboot' \
  && su user -c 'wine regedit.exe /s /home/user/tmp/windows.reg' \
  && su user -c 'wineboot' \
  && echo 'quiet=on' > /etc/wgetrc \
  && su user -c 'winetricks -q win7' \
  && su user -c 'winetricks -q /home/user/tmp/winhttp_2ksp4.verb' \
  && su user -c 'winetricks -q msscript' \
  && su user -c 'winetricks -q fontsmooth=rgb' \
  && su user -c 'winetricks -q riched20' \
  \
  && rm -rf /etc/wgetrc /home/user/.cache/ /home/user/tmp/* \
  && echo "Wine: initialized"

ENV \
  LANG=zh_CN.UTF-8 \
  LC_ALL=zh_CN.UTF-8 \
  TZ=Asia/Shanghai
