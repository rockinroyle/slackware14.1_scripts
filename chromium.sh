#!/bin/bash -v

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
