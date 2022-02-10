#!/bin/bash
set -Eeux;

# Get ubuntu codename
source /etc/os-release

# Delete all Linux headers
PKGS_LINUX_HEADERS=( $(dpkg --list | awk '{ print $2 }' | grep 'linux-headers' || true) );
apt-get -y purge --autoremove "${PKGS_LINUX_HEADERS[@]:+${PKGS_LINUX_HEADERS[@]}}";

# Delete Linux source
PKGS_LINUX_SOURCE=( $(dpkg --list | awk '{ print $2 }' | grep 'linux-source' || true) );
apt-get -y purge --autoremove "${PKGS_LINUX_SOURCE[@]:+${PKGS_LINUX_SOURCE[@]}}";

# Delete development packages
PKGS_DEV=( $(dpkg --list | awk '{ print $2 }' | grep -- '-dev$' || true) );
apt-get -y purge --autoremove "${PKGS_DEV[@]:+${PKGS_DEV[@]}}";
# delete docs packages
PKGS_DOC=( $(dpkg --list | awk '{ print $2 }' | grep -- '-doc$' || true) );
apt-get -y purge --autoremove "${PKGS_DOC[@]:+${PKGS_DOC[@]}}";

# Delete X11 libraries
PKGS_X11=( \
  libx11-data \
  xauth \
  libxmuu1 \
  libxcb1 \
  libx11-6 \
  libxext6 \
  libxau6 \
);
apt-get -y purge --autoremove "${PKGS_X11[@]}";

# Delete obsolete networking
PKGS_OBSOLETE_NETWORKING=( \
  ppp \
  pppconfig \
  pppoeconf \
);
apt-get -y purge --autoremove "${PKGS_OBSOLETE_NETWORKING[@]}";

# Delete oddities
PKGS_ODDITIES=( \
  popularity-contest \
  installation-report \
  command-not-found* \
  friendly-recovery \
  bash-completion \
  fonts-ubuntu-font-family-console \
  laptop-detect \
);
apt-get -y purge --autoremove "${PKGS_ODDITIES[@]}";

# Remove specific Linux kernels, such as linux-image-3.11.0-15-generic but
# keeps the current kernel and does not touch the virtual packages,
# e.g. 'linux-image-generic', etc.
PKGS_LINUX_IMAGE=( $(dpkg --list | awk '{ print $2 }' | grep -E '(linux-image-.*-generic)|(linux-cloud-tools.*)|(linux-tools.*)|(linux-modules.*)' | grep -v `uname -r | sed 's/-generic//'` | grep -v common || true) );
apt-get -y purge --autoremove "${PKGS_LINUX_IMAGE[@]:+${PKGS_LINUX_IMAGE[@]}}";
apt-get -y purge --autoremove linux-cloud-tools*

# Exlude the files we don't need w/o uninstalling linux-firmware
#echo "==> Setup dpkg excludes for linux-firmware"
#cat <<_EOF_ | cat >> /etc/dpkg/dpkg.cfg.d/excludes
##PACKER-BEGIN
#path-exclude=/lib/firmware/*
#path-exclude=/usr/share/doc/linux-firmware/*
##PACKER-END
#_EOF_

# Delete the massive firmware packages
#rm -rf /lib/firmware/*
#rm -rf /usr/share/doc/linux-firmware/*

# Remove firmware
apt-get -y purge --autoremove linux-firmware

# Delete some packages
PKGS_OTHER=( \
  usbutils \
  libusb-1.0-0 \
  binutils \
  console-setup \
  console-setup-linux \
  cpp* \
  wireless-regdb \
  eject \
  file \
  keyboard-configuration \
  krb5-locales \
  libmagic1 \
  make \
  manpages \
  netcat-openbsd \
  os-prober \
  tasksel \
  tasksel-data \
  vim-common \
  whiptail \
  xkb-data \
  pciutils \
  ubuntu-advantage-tools \
  tcpd \
  byobu git* \
  binutils make manpages libmpc3 \
);
apt-get -y purge --autoremove "${PKGS_OTHER[@]}";

PKGS_OTHER_ADDITION=( \
  crda \
  iw \
);
apt-get -y purge --autoremove "${PKGS_OTHER_ADDITION[@]}";

# Check to clean again...
apt-get -y autoremove;
apt-get -y clean all;
rm -rf /var/lib/apt/*;
mkdir -p /var/lib/apt/lists;
rm -rf /var/log/vboxadd*

# Remove docs
rm -rf /usr/share/doc/*

# Remove caches
find /var/cache -type f -exec rm -rf {} \;

# truncate any logs that have built up during the install
find /var/log -type f -exec truncate --size=0 {} \;

# Blank netplan machine-id (DUID) so machines get unique ID generated on boot.
truncate -s 0 /etc/machine-id

# remove the contents of /tmp and /var/tmp
rm -rf /tmp/* /var/tmp/*

# clear the history so our install isn't there
export HISTSIZE=0
rm -f /root/.wget-hsts

# remove floppy
sed -i '/.*\/media\/floppy.*/d' /etc/fstab

# ensure apt source
truncate -s 0 /etc/apt/apt.conf

if [ x"$UBUNTU_CODENAME" != "x" ]; then
  cat << _EOF_ > /etc/apt/sources.list
deb mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME main restricted
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME main restricted

deb mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME-updates main restricted
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME-updates main restricted

deb mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME universe
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME universe
deb mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME-updates universe
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME-updates universe

deb mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME multiverse
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME multiverse
deb mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME-updates multiverse
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME-updates multiverse

deb mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME-backports main restricted universe multiverse
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME-backports main restricted universe multiverse

#deb http://archive.canonical.com/ubuntu $UBUNTU_CODENAME partner
#deb-src http://archive.canonical.com/ubuntu $UBUNTU_CODENAME partner

deb mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME-security main restricted
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME-security main restricted
deb mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME-security universe
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME-security universe
deb mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME-security multiverse
#deb-src mirror://mirrors.ubuntu.com/mirrors.txt $UBUNTU_CODENAME-security multiverse
_EOF_
fi

