# docker-windows [![Docker](https://github.com/huan/docker-windows/workflows/Docker/badge.svg)](https://github.com/huan/docker-windows/actions?query=workflow%3ADocker)

[![dockeri.co](https://dockeri.co/image/zixia/windows)](https://hub.docker.com/r/zixia/windows/)

Run Windows Applications in a Linux Docker Container

![Wine](https://huan.github.io/docker-windows/images/wine.png)

> Image Credit: [How To Run Windows Applications And Games On Linux](https://www.ostechnix.com/run-windows-games-softwares-ubuntu-16-04/)

## Features

1. Dockerize Microsoft Windows Applications on Linux
1. GUI Enabled via Remote Desktop in Web Browser

## Examples

To be added.

## Usage

### Environment variables

* **`USER_PASSWD`** - user `user` password (default: `Passw0rd`)
* **`VNC_PASSWD`** - VNC password, max 8 chars (default: `Passw0rd`)
* **`VNC_GEOMETRY`** - VNC geometry (default: `1600x900`)
* **`VNC_DEPTH`** - VNC depth (default: `16`)

### Ports

* **5900** - VNC (tigervnc)
* **80** - Web (websockify)

To be writen.

## Links

### Development Tools

- [Cross-compiling for Windows - Ubuntu, wine and Microsoft Visual C++](https://ooo-imath.sourceforge.io/wiki/index.php/Cross-compiling_for_Windows#Visual_Studio_2015)
- [Using Visual Studio Compiler with Wine](https://github.com/eruffaldi/wine_vcpp)
- [A C++ Hello World And A Glass Of Wine, Oh My !](https://hackernoon.com/a-c-hello-world-and-a-glass-of-wine-oh-my-263434c0b8ad)

### Wine Installation

- [Wine HQ - Ubuntu Installing WineHQ packages](https://wiki.winehq.org/Ubuntu)
- [How to Install Wine 5.0 Stable in Ubuntu 18.04, 19.10](http://ubuntuhandbook.org/index.php/2020/01/install-wine-5-0-stable-ubuntu-18-04-19-10/)
- [PlayOnLinux Explained: Components Part 1](https://www.gamersonlinux.com/forum/threads/playonlinux-explained-components-part-1.273/)
- [Wine HQ - Cheat Engine - crashes attaching to app?](https://forum.winehq.org/viewtopic.php?t=33248&p=125564)
- [BSMG Linux Modding Guide](https://bsmg.wiki/modding/linux.html)

## History

### master

### v0.1 (Feb 15, 2020)

VNC Works like a charm in Docker Container with Web Client.

1. [TigerVNC](https://tigervnc.org/) - Tiger VNC (Virtual Network Computing) is a client/server application that allows users to launch and interact with graphical applications on remote machines.
1. [NoVNC](https://github.com/novnc/noVNC) - VNC Client Web Application.

### v0.0.1 (Feb 13, 2020)

1. Inited.

## Thanks

1. [Docker noVNC](https://github.com/oott123/docker-novnc) by [@oott123](https://github.com/oott123) - tigervnc, websokify, novnc and Nginx with s6-overlay in a docker image

## Author

[Huan LI](https://github.com/huan) ([李卓桓](http://linkedin.com/in/zixia)) zixia@zixia.net

[![Profile of Huan LI (李卓桓) on StackOverflow](https://stackexchange.com/users/flair/265499.png)](https://stackexchange.com/users/265499)

## Copyright & License

* Code & Docs © 2020-now Huan LI \<zixia@zixia.net\>
* Code released under the Apache-2.0 License
* Docs released under Creative Commons
