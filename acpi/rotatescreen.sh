#!/bin/sh
#
# This script rotates the display in TabletPCs when screen is changed from
# laptop to tablet mode, or when rotation button is pressed

test -f /usr/share/acpi-support/key-constants || exit 0

. /usr/share/acpi-support/power-funcs

if [ -f /var/lib/acpi-support/screen-rotation ] ; then
	read ROTATION </var/lib/acpi-support/screen-rotation
fi

case "$ROTATION" in
	right)
	NEW_ROTATION="normal"
	;;
	*)
	NEW_ROTATION="right"
	;;
esac

d=/tmp/.X11-unix
for x in $d/X*; do
	displaynum=${x#$d/X}
	getXuser;
	if [ "x$XAUTHORITY" != x ]; then
	    export DISPLAY=":$displaynum"
	    /usr/bin/xrandr -o $NEW_ROTATION && echo $NEW_ROTATION > /var/lib/acpi-support/screen-rotation
	    if [ -x /usr/bin/xsetwacom ]; then
	        OIFS=$IFS
	        IFS='
'
	        WACOMDEVICES=`xsetwacom --list | awk NF--`
	        for device in $WACOMDEVICES; do
	            if [ "$NEW_ROTATION" = "normal" ]; then
	                xsetwacom set "$device" rotate NONE
	            else
	                xsetwacom set "$device" rotate CW
	            fi
	        done
	        IFS=$OIFS
	    fi
	fi
done

