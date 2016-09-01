#!/bin/bash
# -*- Mode: sh; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
#
# Authors:
#   Sam Hewitt <sam@snwh.org>
#
# Description:
#   A script for removing OS X/mac OS pkg files
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

# Declarations
# PKGS=( "com.example.pkg" "com.another-example.pkg")
PKGS=( )

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


# Forget pkg
function forget_pkg {
	# Forget the pkg
	show_question "About to forget the pkg '$PKGNAME', are you sure? (Y)es (No)"
	read REPLY
	case $REPLY in
	[Yy]* ) 
    	show_info 'Forgetting...'
    	show_warning 'Requires root privileges'
		sudo pkgutil --forget $PKGNAME
		;;
	[Nn]* )
		show_info 'OK, proceeding...'
		;;
	* )
	    show_error '\aSorry, try again.'
	    forget_pkg
	    ;;
	esac
}

# Delete pkg files/directors
function delete_pkg {
	# Remove files and directories installed by the pkg# Forget the pkg
	show_question "About to delete all files & directories installed by '$PKGNAME', are you sure? (Y)es (No)"
	read REPLY
	case $REPLY in
	[Yy]* ) 
		show_warning 'Deleting pkg contents...'
		pkgutil --only-files --files $PKGNAME | tr '\n' '\0' | xargs -n 1 -0 sudo rm -i
		pkgutil --only-dirs --files $PKGNAME | tr '\n' '\0' | xargs -n 1 -0 sudo rm -ir
		show_success 'Done.'
		# Run forget function
		forget_pkg
		;;
	[Nn]* )
		show_info 'OK, proceeding...'
		;;
	* )
	    show_error '\aSorry, try again.'
	    delete_pkg
	    ;;
	esac
}

# Main
function main {
	for PKGNAME in "${PKGS[@]}"
	do

	# Change directory to / (assuming the package is rooted at /)
	cd / 
	
	# Run delete function
	delete_pkg

	# Change directory back to home
	cd

	# Done
	show_success 'Done.'

	done
}

# Run
if [ ${#PKGS[@]} -eq 0 ]; then
    show_warning "No pkgs selected. Find some pkgs with 'pkgutil --pkgs' and update this array."
else
    main
fi

#EOF