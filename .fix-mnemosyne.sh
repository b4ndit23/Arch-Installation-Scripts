#!/bin/bash
set -euo pipefail

echo "=== Fixing Mnemosyne after Hermes update ==="

cd ~/.hermes/hermes-agent
source venv/bin/activate

echo "Upgrading mnemosyne-hermes..."
pip install --upgrade mnemosyne-hermes

echo "Creating symlink..."
mkdir -p ~/.hermes/plugins/mnemosyne
ln -sfn "$(python -c 'import pathlib, mnemosyne_hermes; print(pathlib.Path(mnemosyne_hermes.__file__).resolve().parent)')"/** ~/.hermes/plugins/mnemosyne/

hermes config set memory.provider mnemosyne

echo "Restarting gateway..."
hermes gateway restart

echo "=== Verification ==="
hermes memory status
mnemosyne stats

echo "✅ Mnemosyne should now be active."
