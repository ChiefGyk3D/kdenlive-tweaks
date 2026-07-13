#!/usr/bin/env bash
set -euo pipefail

PYTHON="${1:-/usr/bin/python3}"

echo "==> Checking packages via: ${PYTHON}"

"${PYTHON}" - <<'PY'
import sys
import importlib.metadata as meta

results = {}

def check(pkg, import_name=None):
    name = import_name or pkg
    try:
        mod = __import__(name)
        try:
            ver = meta.version(pkg)
        except Exception:
            ver = getattr(mod, '__version__', 'installed')
        results[pkg] = ('OK', ver)
    except ImportError as e:
        results[pkg] = ('MISSING', str(e))

check('openai-whisper', 'whisper')
check('srt')
check('opencv-python', 'cv2')
check('torch')
check('sam2')

print()
all_ok = True
for pkg, (status, info) in results.items():
    mark = '✓' if status == 'OK' else '✗'
    print(f"  {mark} {pkg}: {info}")
    if status != 'OK':
        all_ok = False

try:
    import torch
    print()
    print(f"  CUDA available : {torch.cuda.is_available()}")
    if torch.cuda.is_available():
        print(f"  CUDA device    : {torch.cuda.get_device_name(0)}")
        print(f"  CUDA version   : {torch.version.cuda}")
        print(f"  torch build    : {torch.__version__}")
    else:
        print("  WARNING: CUDA not available — Kdenlive will use CPU (slow)")
except Exception as e:
    print(f"  torch check failed: {e}")

print()
if all_ok:
    print("All packages OK.")
else:
    print("Some packages missing. Re-run install-ai-deps.sh.")
    sys.exit(1)
PY