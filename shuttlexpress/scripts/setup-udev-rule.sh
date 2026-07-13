#!/usr/bin/env bash
set -euo pipefail

RULE_FILE="/etc/udev/rules.d/90-contour-shuttleXpress.rules"
RULE_LINE='SUBSYSTEMS=="usb", ATTRS{idVendor}=="0b33", ATTRS{idProduct}=="0020", MODE="0444"'

echo "Installing udev rule for Contour ShuttleXpress..."
echo "${RULE_LINE}" | sudo tee "${RULE_FILE}" >/dev/null
sudo udevadm control --reload-rules
sudo udevadm trigger

echo "Done. Unplug and replug ShuttleXpress, then run ./check-device.sh"