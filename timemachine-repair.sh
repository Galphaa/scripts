#!/bin/bash
# -*- Mode: sh; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
#
# Authors:
#   Sam Hewitt <sam@snwh.org>
#
# Description:
#   A script for repairing a network Time Machine backup.
#
# Legal Stuff:
#
# This script is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; version 3.
#
# This script is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, see <https://www.gnu.org/licenses/gpl-3.0.txt>

# root check
if [[ $(whoami) != 'root' ]]; then
    exit 1
fi

# TM_HOSTNAME=$(hostname -s | sed -e 's/-/ /g')
TM_HOSTNAME='deepblue.local' # Time Machine Hostname
MOUNTPOINT='/Volumes/TimeMachine' # Mountpoint
SPARSEBUNDLE='iMac.sparsebundle' # Name of the backed-up computer's sparsebundle
PLIST=$SPARSEBUNDLE/com.apple.TimeMachine.MachineID.plist # plist file

# Disable Time Machine service
echo "Disabling Time Machine service..."
tmutil disable
echo "Done."

# Mount network Time Machine
echo "Mounting volume..."
mkdir $MOUNTPOINT
read -s -p 'Enter Time Machine Password: ' $PASSWORD
mount_afp afp://timemachine:$PASSWORD@$TM_HOSTNAME/TimeMachine $MOUNTPOINT
echo "Done."

# Change sparsebundle flags to avoid "read-only filesystem" error
echo "Changing file and folder flags..."
cd $MOUNTPOINT
chflags -R nouchg $SPARSEBUNDLE
echo "Done."

# Attach sparsebundle
echo "Attaching sparsebundle..."
DISK=`hdiutil attach -nomount -readwrite -noverify -noautofsck $SPARSEBUNDLE | grep Apple_HFS | cut -f 1`
echo "Done."

# Repair sparsebundle filesystem
echo "Repairing volume..."
#diskutil repairVolume $DISK
/sbin/fsck_hfs -fry $DISK
echo "Done."

# Remove properties in PLIST file that would cause problems for future backups.
echo "Fixing Properties..."
cd $MOUNTPOINT
cp "$PLIST" "$PLIST.backup"
sed -e '/RecoveryBackupDeclinedDate/{N;d;}'   \
    -e '/VerificationState/{n;s/2/0/;}'       \
    "$PLIST.backup" \
    > "$PLIST"
echo "Done."

# Unmount volumes
echo "Unmounting volumes..."
cd ~
hdiutil detach /dev/$DISK
umount $MOUNTPOINT
echo "Done."

# Restart Time Machine service
echo "Enabling Time Machine..."
tmutil enable
echo "Done."

# Start a new Time Machine backup
# echo "Starting backup"
# tmutil startbackup
# echo "Done."

# End
echo "Complete"
exit 0

# EOF