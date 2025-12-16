#!/bin/bash
set -e  # Exit on any error

echo "=== Linux Mint Cleanup (Safe Mode) ==="

# APT cleanup (consolidated)
echo "Cleaning APT cache..."
sudo apt clean && sudo apt autoclean && sudo apt autoremove --purge -y

# Thumbnails (full safe delete)
echo "Cleaning thumbnail cache..."
rm -rf ~/.cache/thumbnails

# Memory caches
echo "Clearing memory caches..."
sync && echo 3 | sudo tee /proc/sys/vm/drop_caches >/dev/null

# DNS (with check)
if command -v resolvectl >/dev/null; then
    sudo resolvectl flush-caches 2>/dev/null || sudo systemctl restart systemd-resolved 2>/dev/null
fi

# Journal logs
echo "Cleaning journal logs..."
sudo journalctl --vacuum-time=2weeks

# Space report
echo "=== Before/After Space ==="
du -sh ~/.cache /var/cache/apt/archives /var/log/* 2>/dev/null | head -10
free -h
echo "Cleanup complete! Re-run df -h / for full disk view."
