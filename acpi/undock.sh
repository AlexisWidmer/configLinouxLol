#!/bin/sh

test -f /usr/share/acpi-support/key-constants || exit 0

for device in /sys/devices/platform/dock.*; do
	[ -e "$device/type" ] || continue
	read dt <$dt
	[ "$dt" = dock_station ] || continue
	echo 1 > "$device/undock"
done
