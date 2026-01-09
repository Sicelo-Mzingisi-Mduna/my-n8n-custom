#!/bin/bash
set -euo pipefail

echo "ENV: N8N_PYTHON_VENV_PATH='${N8N_PYTHON_VENV_PATH:-<not-set>}'"

VENV_PATH="/usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv"

echo "=== STARTUP DIAGNOSTICS ==="
id
ls -la "$(dirname "$VENV_PATH")" || true
ls -la "$VENV_PATH" || true
ls -la "$VENV_PATH/bin" || true

if [ -x "$VENV_PATH/bin/python3" ]; then
  echo "python3 exists, version:"
  "$VENV_PATH/bin/python3" --version || true
  "$VENV_PATH/bin/python3" -c "import sys, pkgutil; print('PYTHON OK', sys.executable); print('requests:', pkgutil.find_loader('requests') is not None)" || true
else
  echo "python3 not executable or missing at $VENV_PATH/bin/python3"
fi

echo "=== END DIAGNOSTICS ==="
exec tini -- n8n start
