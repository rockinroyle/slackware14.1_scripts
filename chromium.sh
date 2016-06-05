#!/bin/bash

# Chromium download script for slackware_14.1_x86_64.
# Should be run from root!

#
# Variable declaration
#

TOP="/tmp"
CHROMIUM="$TOP/chromium"
WIDEVINE="$TOP/chromium-widevine"
PEPPER="$TOP/chromium-pepperflash"

#
# Directory structuring
#

if [ ! -e "$CHROMIUM" ] && [ ! -e "$WIDEVINE" ] && [ ! -e "$PEPPER" ]; then
	mkdir "$CHROMIUM" "$WIDEVINE" "$PEPPER"
fi


#
# Cleanup
#

cd $TOP
removepkg chromium-*.t?z
cd $TOP/chromium
rm -rf build
cd $TOP/chromium-pepperflash
rm -rf build
cd $TOP/chromium-widevine
rm -rf build

#
# Download
#

cd $TOP/chromium
lftp -c "open http://www.slackware.com/~alien/slackbuilds/chromium/; mirror build"
cd $TOP/chromium-pepperflash
lftp -c "open http://www.slackware.com/~alien/slackbuilds/chromium-pepperflash-plugin/; mirror build"
cd $TOP/chromium-widevine
lftp -c "open http://www.slackware.com/~alien/slackbuilds/chromium-widevine-plugin/; mirror build"

#
# Build binary packages
#

# Chromium Browser
cd $TOP/chromium/build
sh ./chromium.SlackBuild

# Pepperflash-plugin
cd $TOP/chromium-pepperflash/build
sh ./chromium-pepperflash-plugin.SlackBuild

# Widevine-plugin
cd $TOP/chromium-widevine/build
sh ./chromium-widevine-plugin.SlackBuild

#
# Install compiled binary packages
#

cd $TOP
installpkg chromium-*.t?z

exit
