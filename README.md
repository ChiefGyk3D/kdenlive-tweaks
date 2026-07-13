# kdenlive-tweaks

Setup scripts and configuration for Kdenlive on Linux: Contour ShuttleXpress jog controller, GPU-accelerated Whisper speech-to-text, and SAM-2 object detection with CUDA 13.2 support.

Tested on:
- Ubuntu 22.04 / Pop!_OS
- Kdenlive 26.04
- NVIDIA RTX 5000 series (CUDA 13.2, driver 595.84)

---

## Contents

### [shuttlexpress/](shuttlexpress/)

Configure the Contour ShuttleXpress as a native Kdenlive JogShuttle device on Linux.

- udev rule setup for device access
- Device detection and event node discovery
- Recommended 5-button mapping for Kdenlive editing
- Input Remapper fallback profile

### [ai-tools/](ai-tools/)

Install and configure GPU-accelerated AI features for Kdenlive:

- Whisper speech-to-text (openai-whisper, CUDA-accelerated)
- SAM-2 object detection
- OpenCV and SRT support
- Supports both Kdenlive venv and system packages mode

---

## Quick Start

### ShuttleXpress

```bash
cd shuttlexpress
sudo ./scripts/setup-udev-rule-shuttlexpress.sh
./scripts/check-device.sh
```

Then in Kdenlive: Settings → Configure Kdenlive → JogShuttle → enable and set device to the detected `/dev/input/eventX`.

### AI Tools (system packages mode)

```bash
cd ai-tools
./scripts/install-ai-deps.sh --system
```

Then in Kdenlive: Settings → Configure Kdenlive → Plugins → set Python to `/usr/bin/python3`, check **Use system packages only** under Object Detection.

---

## Requirements

- Linux (Debian/Ubuntu/Pop!_OS recommended)
- Python 3.10+
- NVIDIA GPU with CUDA 12.6+ (13.2 recommended for RTX 5000 series)
- Kdenlive 26.04+
- `ffmpeg`, `usbutils`, `evtest`

---

## License

MIT
