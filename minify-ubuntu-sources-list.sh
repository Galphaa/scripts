#!/bin/bash
# -*- Mode: sh; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
#
# Authors:
#   Sam Hewitt <sam@snwh.org>
#
# Description:
#   A script to minify the 'sources.list' file on an apt-based Linux distibution
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

# Fancy echos
show_error(){
echo -e "\033[1;31m$@\033[m" 1>&2
}
show_info(){
echo -e "\033[1;35m$@\033[0m"
}
show_warning(){
echo -e "\033[1;33m$@\033[0m"
}
show_question(){
echo -e "\033[1;34m$@\033[0m"
}
show_success(){
echo -e "\033[1;36m$@\033[0m"
}

# Declarations
DISTRO='Ubuntu'
VERSION=xenial
LOCATION="ca."

function list_create {
	show_info "Creating minified 'sources.list'..."
echo "## `echo $DISTRO` Sources List

## Main
deb http://`echo $LOCATION`archive.ubuntu.com/ubuntu/ $VERSION main restricted universe multiverse
# deb-src http://`echo $LOCATION`archive.ubuntu.com/ubuntu/ $VERSION main restricted universe multiverse

## Updates
deb http://`echo $LOCATION`archive.ubuntu.com/ubuntu/ $VERSION-updates main restricted universe multiverse
# deb-src http://`echo $LOCATION`archive.ubuntu.com/ubuntu/ $VERSION-updates main restricted universe multiverse

## Backports
deb http://`echo $LOCATION`archive.ubuntu.com/ubuntu/ $VERSION-backports main restricted universe multiverse
# deb-src http://`echo $LOCATION`archive.ubuntu.com/ubuntu/ $VERSION-backports main restricted universe multiverse

## Proposed
deb http://`echo $LOCATION`archive.ubuntu.com/ubuntu/ $VERSION-proposed main restricted universe multiverse
# deb-src http://`echo $LOCATION`archive.ubuntu.com/ubuntu/ $VERSION-proposed main restricted universe multiverse

## Security
deb http://`echo $LOCATION`archive.ubuntu.com/ubuntu/ $VERSION-security main restricted universe multiverse
# deb-src http://`echo $LOCATION`archive.ubuntu.com/ubuntu/ $VERSION-security main restricted universe multiverse

## Canonical Partner
deb http://archive.canonical.com/ubuntu $VERSION partner
# deb-src http://archive.canonical.com/ubuntu $VERSION partner" >> sources.list
	show_success 'Done.'
}


# Backup system sources.list
function create_backup {
	show_info "Backup original 'sources.list'"
	# Check if backup exists
	if [ ! -f /etc/apt/sources.list.orig ]; then
		show_info "Backup of original 'sources.list' already exists. Continuing..."

		show_info "Creating backup of original 'sources.list'"
	    show_warning 'Requires root privileges'
		sudo cp -r /etc/apt/sources.list /etc/apt/sources.list.orig
	    show_success 'Done.'
	fi	
}

# Replace system sources.list
function list_replace {
	show_info "About to replace the system-created 'sources.list'"
	show_question "Are you sure you want to continue? (Y)es (No)"
	read REPLY
	case $REPLY in
	[Yy]* ) 
		echo '\aReplacing...'
		show_warning 'Requires root privileges'
		sudo cp -r sources.list /etc/apt/
		rm sources.list
		;;
	[Nn]* )
		show_info 'OK, exiting...'
		exit
		;;
	* )
	    show_error '\aSorry, try again.'
	    list_replace
	    ;;
	esac
}

# Replace system sources.list
function refresh_repos {
	show_question "Would you like to refresh the software repository information? (Y)es (No)"
	read REPLY
	case $REPLY in
	[Yy]* ) 
	    # Update repository information
	    show_info 'Updating repository information...'
	    show_warning 'Requires root privileges'
	    sudo apt-get update -y
	    show_success 'Done.'
		;;
	[Nn]* )
		show_info 'OK, continuing...'
		;;
	* )
	    show_error '\aSorry, try again.'
	    refresh_repos
	    ;;
	esac
}

# Main
function main {
	# Backup list
	create_backup
	# Minify list
	list_create
	# Replace list
	list_replace
	# Update repository information
	refresh_repos
}

main
#EOF