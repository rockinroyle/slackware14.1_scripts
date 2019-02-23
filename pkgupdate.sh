#!/bin/sh -v

# Script for downloading and installing packages I use from alienbob repo and other locations.
# See pkglibs.sh scipt for package argument definitions.
# As with installing any package in Slackware, this script should be run in a root login shell

# Copyright (C) 2017-2018 @rockinroyle aka Ralph L Royle III
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/> 

# Source function library

. ./functions.sh
. ./pkglibs.sh

# Variable declarations

USAGE="`basename $0` [-c|-w|-p|-C]" 
ERROR="ERROR! Invalid usage."
TOP="/tmp"
CHROMIUM="$TOP/chromium"
WIDEVINE="$TOP/chromium-widevine"
PEPPER="$TOP/chromium-pepperflash"

# Setup ERROR/USAGE message handling

if [ $# -lt 1 ]; then
	printERROR $ERROR
	printUSAGE $USAGE
	exit 1
fi

# Setup definitions for the script arguments

case "$@" in
	-c)_chr
	   ;;
	-w)_widiv
	   ;;
	-p)_pepp
	   ;;
	-C)_chrbr
	   ;;
	 *)printUSAGE $USAGE
	   exit 1
	   ;;
esac

#
# Directory structuring
#

if [ ! -e "$CHROMIUM" ] && [ ! -e "$WIDEVINE" ] && [ ! -e "$PEPPER" ]; then
	mkdir "$CHROMIUM" "$WIDEVINE" "$PEPPER"
	else echo "Directories already exist. Moving on!"
fi


#
# Cleanup
#

cd $TOP
removepkg chromium-*.t?z
cd $CHROMIUM
rm -rf build
cd $PEPPER
rm -rf build
cd $WIDEVINE
rm -rf build

#
# Download
#

cd $CHROMIUM
lftp -c "open http://www.slackware.com/~alien/slackbuilds/chromium/; mirror build"
cd $PEPPER
lftp -c "open http://www.slackware.com/~alien/slackbuilds/chromium-pepperflash-plugin/; mirror build"
cd $WIDEVINE
lftp -c "open http://www.slackware.com/~alien/slackbuilds/chromium-widevine-plugin/; mirror build"

#
# Build binary packages
#

# Chromium Browser
cd $CHROMIUM/build
sh ./chromium.SlackBuild

# Pepperflash-plugin
cd $PEPPER/build
sh ./chromium-pepperflash-plugin.SlackBuild

# Widevine-plugin
cd $WIDEVINE/build
sh ./chromium-widevine-plugin.SlackBuild

#
# Install compiled binary packages
#

cd $TOP
installpkg chromium-*.t?z

exit
