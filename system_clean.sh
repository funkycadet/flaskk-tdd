#!/bin/bash
# System monthly cleaning script
# Here's what this script will do:

# Removes packages that are no longer required
# Cleans up apt cache
# Clears systemd journal logs
# Removes old revisions of snaps
# Clean thumbnail cache
# CLOSE ALL SNAPS BEFORE RUNNING THIS

echo "Starting system cleaning script..."
echo "Checking for packages that are not required:"
sudo apt-get autoremove
echo "Done checking..."
echo "Cleaning cache system-wide..."
sudo apt-get clean
echo "Done..."
echo "Checking journal disk usage"
journalctl --disk-usage
echo "Cleaning journal disk usage up to 3 days..."
journalctl --vacuum-size=900
echo "Checking current journal size:"
journalctl --disk-usage
echo "Checking snap disk usage:"
du -h /var/lib/snapd/snaps
echo "Cleaning older snap versions..."
set -eu
snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        snap remove "$snapname" --revision="$revision"
    done
