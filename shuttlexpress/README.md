# ShuttleXpress for Kdenlive (Linux)

Configures the Contour ShuttleXpress as a native Kdenlive JogShuttle device.

## 1. Install udev rule

```bash
sudo ./scripts/setup-udev-rule-shuttlexpress.sh
```

This writes `/etc/udev/rules.d/90-contour-shuttleXpress.rules` so Linux grants read access to the device.

Unplug and replug the ShuttleXpress after running.

## 2. Find the event node

```bash
./scripts/check-device.sh
```

Output will show the device path, for example:

```
Use this in Kdenlive JogShuttle device field: /dev/input/event20
```

## 3. Configure Kdenlive

Settings → Configure Kdenlive → JogShuttle

- Enable Jog Shuttle device
- Device: `Contour Design ShuttleXpress`
- Device file: `/dev/input/eventX` (from step 2, use by-id path shown for stability)

## 4. Button mapping

Recommended 5-button layout for editing:

| Button | Action | Kdenlive name |
|--------|--------|---------------|
| 1 | Play/Pause | Play |
| 2 | Add Marker | Add Marker |
| 3 | Previous Frame | Rewind 1 Frame |
| 4 | Next Frame | Forward 1 Frame |
| 5 | Cut at playhead | Cut Clip |

Jog wheel: frame-by-frame stepping
Shuttle ring: variable speed playback (J/K/L equivalent)

See `mappings/` for the full CSV reference and Kdenlive shortcut profile.

## Fallback: Input Remapper

If native JogShuttle does not work in your session (e.g. Wayland compositor issues):

```bash
./scripts/start-input-remapper.sh
```

Load the mapping from `mappings/shuttlexpress-kdenlive-template.csv` in the Input Remapper GUI.
