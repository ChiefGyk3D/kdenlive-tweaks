# AI Tools for Kdenlive (Linux, CUDA)

GPU-accelerated speech-to-text, object detection, and subtitle support for Kdenlive on Linux.

Packages installed:
- `openai-whisper` — speech-to-text engine
- `srt` — subtitle file support
- `opencv-python` — computer vision
- `sam-2` — Segment Anything Model 2 (object detection)
- `torch` / `torchvision` — PyTorch with CUDA

## Requirements

- NVIDIA GPU (CUDA 12.6+; CUDA 13.2 recommended for RTX 5000 series)
- Python 3.10+
- Kdenlive 26.04+

## Installation

### System packages mode (recommended)

Use this when **Use system packages only** is checked in Kdenlive → Plugins → Object Detection.

```bash
./scripts/install-ai-deps.sh --system
```

Installs to `~/.local/lib/python3.x/site-packages`.

Point Kdenlive Python path to: `/usr/bin/python3`

### Kdenlive venv mode

Use this when letting Kdenlive manage its own environments.

```bash
./scripts/install-ai-deps.sh --venv
```

Installs into `~/.local/share/kdenlive/venv` and `~/.local/share/kdenlive/venv-sam`.

### Interactive

```bash
./scripts/install-ai-deps.sh
```

Prompts for mode selection.

## Verify

```bash
./scripts/verify-ai-deps.sh
```

Confirms all packages import correctly and CUDA is available.

## Kdenlive configuration

**Speech to Text:**
Settings → Configure Kdenlive → Plugins → Speech to Text
- Engine: Whisper
- Device: GPU
- Download a model (turbo recommended, 1.4 GB)

**Object Detection:**
Settings → Configure Kdenlive → Plugins → Object Detection
- Device: GPU
- Use system packages only: ✓ (if using --system install)
- Python path: `/usr/bin/python3`
