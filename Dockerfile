
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
      vim \
    \
    apt-transport-https \
    ca-certificates \
    curl \
    python-numpy \
    software-properties-common \
    sudo \
    tzdata \
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

COPY ./pkg/vnc/* /

#
# Stage 2: Wine
#

# FROM VNC

# ENV \
#   LANG=zh_CN.UTF-8 \
#   LC_ALL=zh_CN.UTF-8 \
#   TZ=Asia/Shanghai

# RUN curl -sL https://dl.winehq.org/wine-builds/winehq.key | apt-key add - \
#   && apt-add-repository -y https://dl.winehq.org/wine-builds/ubuntu \
#   && dpkg --add-architecture i386 \
#   && curl -J -L -o /usr/local/bin/winetricks https://github.com/Winetricks/winetricks/raw/master/src/winetricks \
#   && chmod 755 /usr/local/bin/winetricks \
#   && curl -J -L -o /usr/share/bash-completion/completions/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks.bash-completion \
#   && echo 'Wine Installed'

# RUN apt-get update \
#   && apt-get install -y \
#     winehq-devel \
#     \
#     cabextract \
#     unzip \
#     language-pack-zh-hans \
#     tzdata \
#     ttf-wqy-microhei \
#   && apt-get autoremove -y \
#   && apt-get clean \
#   && rm -rf /var/lib/apt/lists

# COPY ./pkg/wine/* /

# RUN su user -c 'WINEARCH=win32 /usr/bin/wine wineboot' \
#   && su user -c 'wineboot' \
#   && su user -c '/usr/local/bin/winetricks -q win7' \
#   && su user -c '/usr/local/bin/winetricks -q /tmp/winhttp_2ksp4.verb' \
#   && su user -c '/usr/local/bin/winetricks -q msscript' \
#   && su user -c '/usr/local/bin/winetricks -q fontsmooth=rgb' \
#   && curl -J -L -o /tmp/simsun.zip https://dlsec.cqp.me/docker-simsun \
#   && mkdir -p /home/user/.wine/drive_c/windows/Fonts \
#   && unzip /tmp/simsun.zip -d /home/user/.wine/drive_c/windows/Fonts \
#   && chown -R user:group /home/user/.wine \
#   && rm -rf /home/user/.cache /tmp/*
