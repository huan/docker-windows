FROM zixia/wine:5.0.0

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

# Issue #1
ARG BIN_BAK=/bin.bak

# S6 Overlay
RUN curl -J -L -o /tmp/s6-overlay-amd64.tar.gz "https://github.com/just-containers/s6-overlay/releases/download/v$S6_OVERLAY_VERSION/s6-overlay-amd64.tar.gz" \
  && echo -n "Checking md5sum... " \
  && echo "$S6_OVERLAY_MD5HASH /tmp/s6-overlay-amd64.tar.gz" | md5sum -c - \
  && mv /bin "$BIN_BAK" \
    && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
    && mv /bin/* "$BIN_BAK" \
    && rmdir /bin \
    && mv "$BIN_BAK" /bin \
  && rm /tmp/s6-overlay-amd64.tar.gz

ENTRYPOINT '/init'

RUN if ! getent group group; then groupadd group; fi \
  && if ! id -u user; then useradd -m -g group user; fi \
  && chsh -s /bin/bash user \
  && echo 'user ALL=(ALL:ALL) ALL' >> /etc/sudoers

COPY ./pkg-vnc/* /

USER user
COPY ./pkg-wine/* /

ARG LUNA_DIR=/home/user/.wine/drive_c/windows/Resources/Themes/luna/
ARG LUNA_URL=https://github.com/huan/docker-windows/releases/download/v0.1/luna.msstyles.gz
RUN mkdir -p $LUNA_DIR \
  && curl -sL $LUNA_URL | gzip -d > "$LUNA_DIR/luna.msstyles" \
  && echo 'Theme: luna.msstyles Installed'

ARG FONTS_DIR=/home/user/.wine/drive_c/windows/Fonts/
ARG SIMSUN_URL=https://github.com/huan/docker-windows/releases/download/v0.1/simsun.ttc.gz
RUN mkdir -p $FONTS_DIR \
  && curl -sL $SIMSUN_URL | gzip -d > "$FONTS_DIR/simsun.ttc" \
  && echo "Fonts: simsun.ttc Installed"

# vcrun6
# winetricks vcrun2013
# winetricks vcrun2015
# winetricks vcrun2017
  # && su user -c 'winetricks -q corefonts' \

# winetricks dbghelp
# winetricks wininet # WinHttpGetIEProxyConfigForCurrentUser failed

RUN WINEARCH=win32 /usr/bin/wine wineboot \
  && wine regedit.exe /s /home/user/tmp/windows.reg \
  && wineboot \
  && sudo -c 'echo "quiet=on" > /etc/wgetrc' \
  && winetricks -q win7 \
  && winetricks -q /home/user/tmp/winhttp_2ksp4.verb \
  && winetricks -q msscript \
  && winetricks -q fontsmooth=rgb \
  && winetricks -q riched20 \
  \
  && sudo rm -rf /etc/wgetrc /home/user/.cache/ /home/user/tmp/* \
  && echo "Wine Initialized"

# WebSocketify & novnc
EXPOSE 80/tcp
# TigerVNC
EXPOSE 5900/tcp

COPY [A-Z]* /
COPY VERSION /VERSION.docker-windows

ENV \
  LANG=zh_CN.UTF-8 \
  LC_ALL=zh_CN.UTF-8 \
  TZ=Asia/Shanghai
