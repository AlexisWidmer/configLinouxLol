#!/bin/sh

set -e

pff=/usr/share/acpi-support/power-funcs
[ -f $pff ] || exit 0

atp_error() {
	logger -t${0##*/} -perr -- $*
	exit 1
}

. $pff || atp_error "Sourcing $pff failed"

[ -x /usr/bin/xinput ] || atp_error "Please install package xinput to enable toggling of touchpad devices."

getXconsole

getTouchDeviceId()
{
    # extract the device id for the supplied touch device name
    # XXX:	according to man page 'list', 'list-props' and 'set-int-prop' are
    #	options, not arguments.
    xinput --list | sed -nr "s|.*$1.*id=([0-9]+).*|\1|p"
}

ENABLEPROP="Synaptics Off"
# Get the xinput device number and enabling property for the touchpad
XINPUTNUM=$(getTouchDeviceId "SynPS/2 Synaptics TouchPad")

if [ -z "$XINPUTNUM" ]; then
    XINPUTNUM=$(getTouchDeviceId "PS/2 Elantech Touchpad")
    ENABLEPROP="Device Enabled"
fi

# if we failed to get an input, exit
[ "$XINPUTNUM" ] || atp_error "Invalid TouchPad id '$XINPUTNUM'"

# get the current state of the touchpad
TPSTATUS=$(xinput --list-props $XINPUTNUM | awk "/$ENABLEPROP/ { print \$NF }")
case $TPSTATUS in
	[!01])
		atp_error "Invalid TouchPad status '$TPSTATUS'"
		;;
esac

# XXX: '--set-int-prop' deprecated
xcmd="xinput --set-int-prop $XINPUTNUM '$ENABLEPROP' 8"
ledf=/sys/class/leds/asus::touchpad/brightness
if [ $TPSTATUS -eq 0 ]; then
	eval $xcmd 1 || atp_error "Command '$xcmd 1' failed"
	[ ! -w $ledf ] || echo 0 >$ledf ||
		atp_error "Writing 0 to $ledf failed"
else
	eval $xcmd 0 || atp_error "Command '$xcmd 0' failed"
	[ ! -w $ledf ] || echo 1 >$ledf ||
		atp_error "Writing 0 to $ledf failed"
fi
