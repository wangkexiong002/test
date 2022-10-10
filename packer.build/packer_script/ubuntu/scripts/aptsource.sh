#!/bin/bash

# Get ubuntu codename
source /etc/os-release

# ensure apt source
truncate -s 0 /etc/apt/apt.conf

if [ x"${UBUNTU_CODENAME}" != "x" ]; then
  cat << _EOF_ > /etc/apt/sources.list
deb mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME} main restricted
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME} main restricted

deb mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME}-updates main restricted
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME}-updates main restricted

deb mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME} universe
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME} universe
deb mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME}-updates universe
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME}-updates universe

deb mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME} multiverse
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME} multiverse
deb mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME}-updates multiverse
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME}-updates multiverse

deb mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME}-backports main restricted universe multiverse
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME}-backports main restricted universe multiverse

#deb http://archive.canonical.com/ubuntu ${UBUNTU_CODENAME} partner
#deb-src http://archive.canonical.com/ubuntu ${UBUNTU_CODENAME} partner

deb mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME}-security main restricted
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME}-security main restricted
deb mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME}-security universe
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME}-security universe
deb mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME}-security multiverse
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt ${UBUNTU_CODENAME}-security multiverse
_EOF_
fi

