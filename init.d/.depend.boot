TARGETS = mountkernfs.sh hostname.sh udev keyboard-setup mountdevsubfs.sh hwclock.sh hdparm checkroot.sh mtab.sh checkroot-bootclean.sh kmod checkfs.sh mountall.sh mountall-bootclean.sh urandom procps pppd-dns udev-mtab networking rpcbind nfs-common mountnfs.sh mountnfs-bootclean.sh kbd console-setup alsa-utils x11-common bootmisc.sh screen-cleanup
INTERACTIVE = udev keyboard-setup checkroot.sh checkfs.sh kbd console-setup
udev: mountkernfs.sh
keyboard-setup: mountkernfs.sh udev
mountdevsubfs.sh: mountkernfs.sh udev
hwclock.sh: mountdevsubfs.sh
hdparm: mountdevsubfs.sh udev
checkroot.sh: hwclock.sh mountdevsubfs.sh hostname.sh hdparm keyboard-setup
mtab.sh: checkroot.sh
checkroot-bootclean.sh: checkroot.sh
kmod: checkroot.sh
checkfs.sh: checkroot.sh mtab.sh
mountall.sh: checkfs.sh checkroot-bootclean.sh
mountall-bootclean.sh: mountall.sh
urandom: mountall.sh mountall-bootclean.sh hwclock.sh
procps: mountkernfs.sh mountall.sh mountall-bootclean.sh udev
pppd-dns: mountall.sh mountall-bootclean.sh
udev-mtab: udev mountall.sh mountall-bootclean.sh
networking: mountkernfs.sh mountall.sh mountall-bootclean.sh urandom
rpcbind: networking mountall.sh mountall-bootclean.sh
nfs-common: rpcbind hwclock.sh
mountnfs.sh: mountall.sh mountall-bootclean.sh networking rpcbind nfs-common
mountnfs-bootclean.sh: mountall.sh mountall-bootclean.sh mountnfs.sh
kbd: mountall.sh mountall-bootclean.sh mountnfs.sh mountnfs-bootclean.sh
console-setup: mountall.sh mountall-bootclean.sh mountnfs.sh mountnfs-bootclean.sh kbd
alsa-utils: mountall.sh mountall-bootclean.sh mountnfs.sh mountnfs-bootclean.sh
x11-common: mountall.sh mountall-bootclean.sh mountnfs.sh mountnfs-bootclean.sh
bootmisc.sh: mountall-bootclean.sh mountnfs-bootclean.sh checkroot-bootclean.sh mountall.sh mountnfs.sh udev
screen-cleanup: mountall.sh mountall-bootclean.sh mountnfs.sh mountnfs-bootclean.sh
