#! /bin/bash

# Create a clickable macOS app bundle from the downloaded Crusader-gui

# Usage: sh ./create-crusader-macos-app.sh 
#
# For example:
#  sh ./create-crusader-macos-app.sh 

# Output is a clickable app, saved within the repo
# The app bundle is .gitignored, so the repo isn't too big

APP_BUNDLE_NAME="Crusader.app"
CRUSADER_VERSION="0.3.2"

# Crusader downloads are at: 
# https://github.com/Zoxc/crusader/releases/download/v0.3.2/Crusader-macOS-ARM-64-bit.tar.gz
# https://github.com/Zoxc/crusader/releases/download/v0.3.2/Crusader-macOS-X86-64-bit.tar.gz

echo ""
echo "*** Update Crusader version number within the script before running..."
echo ""

# Remove the previous Crusader.app bundle and rebuild anew
rm -rf "$APP_BUNDLE_NAME"

# Create directories for both the x86 and arm64 versions of Crusader
mkdir -p "$APP_BUNDLE_NAME/Contents/Resources/x86/"
mkdir -p "$APP_BUNDLE_NAME/Contents/Resources/arm64/"

echo "Downloading Crusader binary x86"
wget -O - -q "https://github.com/Zoxc/crusader/releases/download/v$CRUSADER_VERSION/Crusader-macOS-X86-64-bit.tar.gz" | \
	tar -xz -f - -C "$APP_BUNDLE_NAME/Contents/Resources/x86/" 

echo "Downloading Crusader binary arm64"
wget -O - -q "https://github.com/Zoxc/crusader/releases/download/v$CRUSADER_VERSION/Crusader-macOS-ARM-64-bit.tar.gz" | \
	tar -xz -f - -C "$APP_BUNDLE_NAME/Contents/Resources/arm64/" 

# Copy the CFBundleExecutable script that launches Crusader & make it executable
echo "Adding CFBundleExecutable startup script"
mkdir -p "$APP_BUNDLE_NAME/Contents/MacOS"
cp run-crusader.sh "$APP_BUNDLE_NAME/Contents/MacOS/run-crusader.sh"
chmod +x "$APP_BUNDLE_NAME/Contents/MacOS/run-crusader.sh"

# Copy in the Info.plist & update short version string
echo "Updating Info.plist"
cp Info.plist "$APP_BUNDLE_NAME/Contents"
NEW_VERSION="Crusader $CRUSADER_VERSION"
plist_path="$APP_BUNDLE_NAME/Contents/Info.plist"
python3 ./update_plist.py "$plist_path" "$NEW_VERSION"

# Copy in the .icns file
echo "Adding .icns"
cp Crusader.icns "$APP_BUNDLE_NAME/Contents/Resources"

echo "Done"
