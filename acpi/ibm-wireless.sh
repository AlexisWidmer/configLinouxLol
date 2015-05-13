#!/bin/sh

test -f /usr/share/acpi-support/state-funcs || exit 0

read vendor </sys/class/dmi/id/sys_vendor 2>/dev/null || exit 0
case $vendor in
	[iI][bB][mM]*)
		;;
	[lL][eE][nN][oO][vV][oO]*)
		;;
	*)
		exit 0
		;;
esac

if ! test -x /usr/sbin/rfkill
then
logger -t${0##*/} -perr -- "Error: Please install package rfkill to enable toggling of wireless devices."
exit 0
fi


# Find and toggle wireless of bluetooth devices on ThinkPads

. /usr/share/acpi-support/state-funcs
. /etc/default/acpi-support

rfkill list | sed -n -e'/tpacpi_bluetooth_sw/,/^[0-9]/p' | grep -q 'Soft blocked: yes'
bluetooth_state=$?

# Note that this always alters the state of the wireless!
toggleAllWirelessStates;

# Sequence is Both on, Both off, Wireless only, Bluetooth only
if ! isAnyWirelessPoweredOn; then
    # Wireless was turned off
    if [ "$bluetooth_state" = 0 ]; then
      if [ x$WIRELESS_BLUETOOTH_SYNC != xtrue ]; then
        rfkill unblock bluetooth
      fi
    else
        rfkill block bluetooth
    fi
else
    if [ x$WIRELESS_BLUETOOTH_SYNC = xtrue -a "$bluetooth_state" = 0 ]; then
	rfkill unblock bluetooth
    fi
fi
