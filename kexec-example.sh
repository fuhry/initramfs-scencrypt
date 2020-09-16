#!/bin/bash

# This script will copy the initramfs to /dev/shm, add the plain key file and use kexec to
# load the new kernel+initrd+cmdline. Afterwards you can trigger kexec directly or via systemd.
# You could install a pacman hook for automation, ex: /etc/pacman.d/hooks/100-kexec-load.hook
# [Trigger]
# Type = File
# Operation = Install
# Operation = Upgrade
# Target = boot/vmlinuz-linux
# Target = boot/initramfs-linux.img
# [Action]
# Description = Preparing kexec
# When = PostTransaction
# Exec = /home/choopm/bin/kexec-load.sh linux

LINUX="${1:-linux}"
INITRAMFS="/boot/initramfs-$LINUX.img"
KERNEL="/boot/vmlinuz-$LINUX"
KEYFILE="/home/choopm/.luks.key"

umask 0077
CRYPTROOT_TMPDIR="$(mktemp -d --tmpdir=/dev/shm)"
INITRD="${CRYPTROOT_TMPDIR}/initrd.img"
ROOTFS="$CRYPTROOT_TMPDIR/rootfs"
FILENAME="keyfile.bin"
CMDLINE=$(echo "$(cat /proc/cmdline | sed 's/cryptkey[^ ]*//') cryptkey=rootfs:/${FILENAME}")
KVERSION=$(file $KERNEL | sed -r 's/.*version ([^ ]*).*/\1/')
mkdir -p $ROOTFS

cleanup() {
    shred -fu "$ROOTFS/$FILENAME" || true
    shred -fu "$INITRD" || true
    rm -rf "${CRYPTROOT_TMPDIR}"
}
trap cleanup INT TERM EXIT

echo "==> Patching and kexec-loading ${INITRD}"

cd "${ROOTFS}"
cat "${INITRAMFS}" | gzip -cd | cpio --quiet -i
cp $KEYFILE $FILENAME
find . | cpio --quiet -H newc -o | gzip >> "${INITRD}"

/usr/bin/kexec -l "${KERNEL}" --initrd="${INITRD}" --command-line="${CMDLINE}"
echo "==> Loaded kernel ${KVERSION}, use: systemctl kexec to reboot"

