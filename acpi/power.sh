#!/bin/sh

test -f /usr/share/acpi-support/key-constants || exit 0

. /usr/share/acpi-support/power-funcs
. /usr/share/acpi-support/policy-funcs

if [ -z "$*" ] && { CheckPolicy || CheckUPowerPolicy; }; then
    exit;
fi

pm-powersave $*
