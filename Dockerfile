FROM ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive
ARG S6_OVERLAY_VERSION=1.22.1.0
ARG S6_OVERLAY_MD5HASH=3060e2fdd92741ce38928150c0c0346a

ENV DISPLAY=:0
ENV LANG='C.UTF-8'
ENV LC_ALL='C.UTF-8'
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV TERM='xterm'
ENV USER_PASSWD=Passw0rd
ENV VNC_DEPTH=16
ENV VNC_GEOMETRY=1400x720
ENV VNC_PASSWD=Passw0rd

#
# openbox
# novnc
# tigervnc
# websockify
# xterm
#
RUN apt-get update \
  && apt-get install -y \
    ca-certificates \
    curl \
    git \
    novnc \
    openbox \
    openssh-client \
    python-numpy \
    sudo \
    tigervnc-standalone-server \
    tzdata \
    vim \
    websockify \
    xterm \
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
  && echo 'user ALL=(ALL:ALL) ALL' >> /etc/sudoers

# WebSocketify & novnc
EXPOSE 80/tcp
# TigerVNC
EXPOSE 5900/tcp

COPY ./pkg/* /