# Kdenlive Shortcut Reference (matched to ShuttleXpress mapping)

Set these in Kdenlive under Settings → Configure Shortcuts.

| Action | Shortcut | Notes |
|--------|----------|-------|
| Play/Pause | Space | Button 1 |
| Add Marker | M | Button 2 |
| Previous Frame | Left | Button 3 / Jog CCW |
| Next Frame | Right | Button 4 / Jog CW |
| Cut Clip | Shift+R | Button 5 — splits clip at playhead |
| Reverse Playback | J | Shuttle ring left |
| Stop | K | Shuttle ring center / release |
| Forward Playback | L | Shuttle ring right |
| Undo | Ctrl+Z | Keyboard only |
| Redo | Ctrl+Shift+Z | Keyboard only |

## Shuttle Ring (outer spring-loaded ring) — TODO

The shuttle ring is working at the hardware level but variable-speed playback
behavior in Kdenlive needs tuning.

**How it is supposed to work:**
- Hold ring slightly right → slow forward playback
- Hold ring further right → faster forward playback
- Hold ring left → reverse playback
- Release → ring snaps to center → playback stops

**Current status:** Ring snaps back correctly (that is correct hardware behavior,
not a bug), but speed control in Kdenlive JogShuttle may need the shuttle
sensitivity or action assignment reviewed.

**To investigate:**
- In Kdenlive JogShuttle settings, confirm shuttle actions are assigned to
  the correct axis (not just buttons 6-9).
- Try `sudo evtest` and select the ShuttleXpress event node to confirm
  shuttle axis events are being emitted while ring is held off-center.
