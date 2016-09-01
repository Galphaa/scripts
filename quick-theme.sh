#!/bin/bash
# -*- Mode: sh; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
#
# Authors:
#   Sam Hewitt <sam@snwh.org>
#
# Description:
#   A script for a quick local installation of an in-development GTK theme
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

THEMENAME=egtk
THEMEDIR=egtk
PROJECTDIR="$HOME/Projects/elementary/"

echo "$THEMENAME development quick render & install script."

# Enter the working directory
echo "Entering working directory..."
cd $PROJECTDIR
echo "Done."

# Synchronize newly rendered icon set with locally installed version (or install if none).
echo "Synchronizing GTK theme with local theme..."
rsync -larvh --delete --progress --exclude='.bzr' $THEMEDIR/ $HOME/.local/share/themes/$THEMENAME
rsync -larvh --delete --progress --exclude='.bzr' $THEMEDIR/ $HOME/.themes/$THEMENAME
echo "Done."

# Reset theme via GSettings
echo "Resetting desktop GTK theme..."
gsettings reset org.gnome.desktop.interface gtk-theme
gsettings reset org.gnome.desktop.wm.preferences theme
echo "Done."

# Set icon theme to eGTK via GSettings
echo "Setting eGTK as desktop GTK theme..."
gsettings set org.gnome.desktop.interface gtk-theme "$THEMENAME"
gsettings set org.gnome.desktop.wm.preferences theme "$THEMENAME"
echo "Done."
