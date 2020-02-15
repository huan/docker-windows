# docker-windows

Run Windows Application in Linux Docker Image

![Wine](https://huan.github.io/docker-windows/images/wine.png)

> Credit: [How To Run Windows Applications And Games On Linux](https://www.ostechnix.com/run-windows-games-softwares-ubuntu-16-04/)

## Features

1. Run Microsoft Windows Application Under GNU/Linux
1. GUI with Remote Desktop Enabled
1. Fully Dockerized

## Usage

winetricks riched20

http://ubuntuhandbook.org/index.php/2020/01/install-wine-5-0-stable-ubuntu-18-04-19-10/
https://tecadmin.net/install-wine-on-ubuntu/
https://wiki.winehq.org/Ubuntu


wine explorer /desktop=arbname,1920x1200 "C:\...\...\application.exe"

## Links

- [Cross-compiling for Windows - Ubuntu, wine and Microsoft Visual C++](https://ooo-imath.sourceforge.io/wiki/index.php/Cross-compiling_for_Windows#Visual_Studio_2015)
- [Using Visual Studio Compiler with Wine](https://github.com/eruffaldi/wine_vcpp)
- [A C++ Hello World And A Glass Of Wine, Oh My !](https://hackernoon.com/a-c-hello-world-and-a-glass-of-wine-oh-my-263434c0b8ad)
- [Wine HQ - Ubuntu Installing WineHQ packages](https://wiki.winehq.org/Ubuntu)

## History

### master

### v0.1 (Feb 15, 2020)

VNC Works like a charm in Docker Container with Web Client.

1. [TigerVNC](https://tigervnc.org/) - Tiger VNC (Virtual Network Computing) is a client/server application that allows users to launch and interact with graphical applications on remote machines.
1. [NoVNC](https://github.com/novnc/noVNC) - VNC Client Web Application.

### v0.0.1 (Feb 13, 2020)

1. Inited.

## Author

[Huan LI](https://github.com/huan) ([李卓桓](http://linkedin.com/in/zixia)) zixia@zixia.net

[![Profile of Huan LI (李卓桓) on StackOverflow](https://stackexchange.com/users/flair/265499.png)](https://stackexchange.com/users/265499)

## Copyright & License

* Code & Docs © 2018-now Huan LI \<zixia@zixia.net\>
* Code released under the Apache-2.0 License
* Docs released under Creative Commons
