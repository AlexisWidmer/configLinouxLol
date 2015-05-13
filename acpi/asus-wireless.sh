#!/bin/sh
# Find and toggle wireless devices on Asus laptops

test -f /usr/share/acpi-support/state-funcs || exit 0

. /usr/share/acpi-support/state-funcs

read vendor </sys/class/dmi/id/sys_vendor 2>/dev/null || exit 0
case $vendor in
	[As][Ss][Uu][Ss]*)
		;;
	*)
		exit 0
		;;
esac

if [ "$1" = "" ] ; then
	toggleAllWirelessStates;
elif isAnyWirelessPoweredOn; then
	if [ "$1" = "off" ] ; then
		toggleAllWirelessStates;
	fi
else
	if [ "$1" = "on" ] ; then
		toggleAllWirelessStates;
	fi
fi

