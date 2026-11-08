#!/usr/bin/env bash
set -euo pipefail

# Install AI packages for Kdenlive (Whisper, SAM-2, OpenCV, srt)
# GPU: NVIDIA RTX 5070 Ti, CUDA 13.2 (driver 595.84)
#
# Usage:
#   ./install-ai-deps.sh --system   # system user site-packages
#                                   # use with "Use system packages only" in Kdenlive
#   ./install-ai-deps.sh --venv     # Kdenlive's own venvs
#   ./install-ai-deps.sh            # prompts for choice

MODE=""
if [[ $# -ge 1 ]]; then
    MODE="$1"
fi

if [[ -z "${MODE}" ]]; then
    echo "Install target:"
    echo "  1) --system  (system user site-packages; use with 'Use system packages only' in Kdenlive)"
    echo "  2) --venv    (Kdenlive's own venvs: ~/.local/share/kdenlive/venv and venv-sam)"
    read -rp "Choice [1/2]: " choice
    case "${choice}" in
        1) MODE="--system" ;;
        2) MODE="--venv" ;;
        *)
            echo "Invalid choice."
            exit 1
            ;;
    esac
fi

KDENLIVE_VENV="${HOME}/.local/share/kdenlive/venv"
KDENLIVE_SAM_VENV="${HOME}/.local/share/kdenlive/venv-sam"

case "${MODE}" in
    --system)
        PIP="/usr/bin/python3 -m pip"
        PIP_FLAGS="--user"
        echo "==> Mode: system user site-packages"
        ;;
    --venv)
        if [[ ! -d "${KDENLIVE_VENV}" ]]; then
            echo "Kdenlive venv not found at ${KDENLIVE_VENV}."
            echo "Open Kdenlive → Configure → Plugins → Speech to Text once first."
            exit 1
        fi
        PIP="${KDENLIVE_VENV}/bin/python -m pip"
        PIP_SAM="${KDENLIVE_SAM_VENV}/bin/python -m pip"
        PIP_FLAGS=""
        echo "==> Mode: Kdenlive venv (${KDENLIVE_VENV})"
        ;;
    *)
        echo "Unknown option: ${MODE}. Use --system or --venv."
        exit 1
        ;;
esac

# Detect CUDA version
CUDA_TOOLKIT=""
if command -v nvidia-smi >/dev/null 2>&1; then
    CUDA_TOOLKIT=$(nvidia-smi 2>/dev/null | grep -oP 'CUDA Version:\s*\K[0-9]+\.[0-9]+' | head -n1)
    DRIVER=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>/dev/null | head -n1)
    echo "==> Driver: ${DRIVER}  CUDA: ${CUDA_TOOLKIT}"
fi

# Pick PyTorch wheel index — https://pytorch.org/get-started/locally/
if [[ -z "${CUDA_TOOLKIT}" ]]; then
    TORCH_INDEX="https://download.pytorch.org/whl/cu132"
    echo "==> nvidia-smi not found, defaulting to cu132"
elif [[ "${CUDA_TOOLKIT}" == 13.2* ]]; then
    TORCH_INDEX="https://download.pytorch.org/whl/cu132"
elif [[ "${CUDA_TOOLKIT}" == 13.0* ]]; then
    TORCH_INDEX="https://download.pytorch.org/whl/cu130"
elif [[ "${CUDA_TOOLKIT}" == 12.6* ]]; then
    TORCH_INDEX="https://download.pytorch.org/whl/cu126"
else
    TORCH_INDEX="https://download.pytorch.org/whl/cu132"
    echo "==> Unrecognised CUDA ${CUDA_TOOLKIT}, defaulting to cu132"
fi
echo "==> PyTorch index: ${TORCH_INDEX}"

echo "==> PyTorch + torchvision..."
# shellcheck disable=SC2086
${PIP} install ${PIP_FLAGS} torch torchvision --index-url "${TORCH_INDEX}"

echo "==> openai-whisper + srt..."
# shellcheck disable=SC2086
${PIP} install ${PIP_FLAGS} --upgrade --no-cache-dir openai-whisper srt

echo "==> opencv-python..."
# shellcheck disable=SC2086
${PIP} install ${PIP_FLAGS} --upgrade opencv-python

echo "==> SAM-2..."
if [[ "${MODE}" == "--venv" ]] && [[ -d "${KDENLIVE_SAM_VENV}" ]]; then
    ${PIP_SAM} install --upgrade "git+https://github.com/facebookresearch/sam2.git"
else
    # shellcheck disable=SC2086
    ${PIP} install ${PIP_FLAGS} --upgrade "git+https://github.com/facebookresearch/sam2.git"
fi

echo ""
echo "Done. Run ./verify-ai-deps.sh to confirm."
