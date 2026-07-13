#!/usr/bin/env bash
set -euo pipefail

echo "== lsusb: Contour/Shuttle =="
if lsusb | grep -iE "Contour|Shuttle"; then
  echo "OK: USB device detected."
else
  echo "WARN: ShuttleXpress not found in lsusb output."
fi

echo
echo "== /proc/bus/input/devices: Contour/Shuttle =="
if grep -iE "Contour|Shuttle" /proc/bus/input/devices; then
  echo "OK: Input device entry detected."
else
  echo "WARN: No input device entry detected."
fi

echo
echo "== Candidate event handler (use in Kdenlive JogShuttle device field) =="
if fgrep Contour -A4 /proc/bus/input/devices; then
  handler="$(fgrep Contour -A4 /proc/bus/input/devices | awk '/Handlers=/ {for (i=1;i<=NF;i++) if ($i ~ /^event[0-9]+$/) print $i}' | head -n1)"
  if [[ -n "${handler}" ]]; then
    echo "Use this in Kdenlive JogShuttle: /dev/input/${handler}"
    echo ""
    echo "Stable by-id path (recommended for config):"
    ls /dev/input/by-id/ | grep -i contour || echo "No by-id entry found."
  fi
fi