#!/bin/bash

set -o errexit -o pipefail

tempdir=$(mktemp -d)

# create DMG for distribution
rm -f template.dmg
hdiutil create -fs HFSX -layout SPUD -size 10m template.dmg -srcfolder $tempdir -format UDRW -volname "Install iChatReader" -quiet
hdiutil attach template.dmg -noautoopen -mountpoint "${tempdir}" -quiet

# do the build with xcode
xcodebuild clean build install -scheme iChatReader -project iChatReader.xcodeproj/ -xcconfig installer-build-settings.xcconfig

cp -rp build/Products/Release/iChatReader.app "${tempdir}"

# cleanup and finalize
hdiutil detach "${tempdir}"
hdiutil convert template.dmg -quiet -format UDZO -imagekey zlib-level=9 -o iChatReader.dmg
