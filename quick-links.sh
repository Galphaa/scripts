#!/bin/bash
# -*- Mode: sh; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
#
# Authors:
#   Sam Hewitt <sam@snwh.org>
#
# Description:
#   A script for quickly creating symlinks for an in-development icon theme
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

THEMENAME="elementary icons"
PROJECTDIR="$HOME/Projects/elementary/icons"

# Icon to be linked to
SOURCE_CONTEXT=places
SOURCE_ICON=user-trash

# Link target
TARGET_CONTEXT=actions
TARGET_ICON=edit-delete

# Icon sizes
DIRECTORIES=('16' '24' '32' '48' '64' '128')

echo "$THEMENAME development quick symlinks script."

# For loop
cd $PROJECTDIR
for directory in "${DIRECTORIES[@]}"
do
	echo "Creating link from '$SOURCE_CONTEXT/$directory/$SOURCE_ICON' to '$TARGET_CONTEXT/$directory/$TARGET_ICON'"
	# Check if target exists
	if [ ! -f $TARGET_CONTEXT/$directory/$TARGET_ICON.svg ]; then
	    rm $TARGET_CONTEXT/$directory/$TARGET_ICON.svg
	    ln -sfr $SOURCE_CONTEXT/$directory/$SOURCE_ICON.svg $TARGET_CONTEXT/$directory/$TARGET_ICON.svg
	else
		ln -sfr $SOURCE_CONTEXT/$directory/$SOURCE_ICON.svg $TARGET_CONTEXT/$directory/$TARGET_ICON.svg
	fi	
done
echo "Done."