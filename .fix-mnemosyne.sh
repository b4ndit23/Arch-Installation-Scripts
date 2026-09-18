#!/bin/bash
set -euo pipefail

echo "=== Fixing Mnemosyne after Hermes update ==="

cd ~/.hermes/hermes-agent
source venv/bin/activate

echo "Upgrading mnemosyne-hermes (pinned <1)..."
pip install --upgrade 'mnemosyne-hermes>=0.7,<1'

hermes config set memory.provider mnemosyne

echo "Restarting gateway..."
hermes gateway restart

echo "=== Verification ==="
hermes memory status
mnemosyne stats

echo "✅ Mnemosyne should now be active."