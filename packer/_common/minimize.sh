#!/bin/sh -eux

case "$PACKER_BUILDER_TYPE" in
  qemu) exit 0 ;;
esac

set +e
swapuuid="`/sbin/blkid -o value -l -s UUID -t TYPE=swap`";
case "$?" in
  2|0) ;;
  *) exit 1 ;;
esac
set -e

if [ "x${swapuuid}" != "x" ]; then
  # Whiteout the swap partition to reduce box size
  # Swap is disabled till reboot
  swappart="`readlink -f /dev/disk/by-uuid/$swapuuid`";
  /sbin/swapoff "$swappart";
  dd if=/dev/zero of="$swappart" bs=1M || echo "dd exit code $? is suppressed";
  /sbin/mkswap -U "$swapuuid" "$swappart";
else
  if [ -f /swapfile ]; then
    /sbin/swapoff /swapfile
  fi

  # The reason why not using fallocate
  # https://unix.stackexchange.com/questions/294600/i-cant-enable-swap-space-on-centos-7
  rm -rf /swapfile
  dd if=/dev/zero of=/swapfile count=2048 bs=1M
  chmod 600 /swapfile
  /sbin/mkswap /swapfile

  if ! cat /etc/fstab | grep -v "^#" | awk '{print $3}' | grep -q swap; then
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
  fi
fi

# Whiteout root
dd if=/dev/zero of=/tmp/whitespace bs=1M || echo "dd exit code $? is suppressed";
rm -rf /tmp/whitespace

