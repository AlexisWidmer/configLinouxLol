#!/bin/sh

test -f /usr/share/acpi-support/key-constants || exit 0

. /etc/default/acpi-support
. /usr/share/acpi-support/power-funcs

. /usr/share/acpi-support/screenblank
