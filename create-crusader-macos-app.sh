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

# CFBundleVersion.txt file holds an incrementing "build" number 
#   so that subsequent versions are treated as distinct
VERSION_FILE="CFBundleVersion.txt"
if [[ -f "$VERSION_FILE" ]]; then
  CURRENT_VERSION=$(cat "$VERSION_FILE")
else
  echo "Version file not found!"
  exit 1
fi
# Increment the version
NEW_VERSION=$((CURRENT_VERSION + 1))
# Update the version file
echo "$NEW_VERSION" > "$VERSION_FILE"

echo ""
echo "*** Update Crusader version number within the script before running..."
echo ""

# Crusader downloads are at: 
# https://github.com/Zoxc/crusader/releases/download/v0.3.2/Crusader-macOS-ARM-64-bit.tar.gz
# https://github.com/Zoxc/crusader/releases/download/v0.3.2/Crusader-macOS-X86-64-bit.tar.gz

echo "Downloading Crusader binary x86"
mkdir -p "x86-binaries/"
wget -O - -q "https://github.com/Zoxc/crusader/releases/download/v$CRUSADER_VERSION/Crusader-macOS-X86-64-bit.tar.gz" | \
  tar -xz -f - -C "x86-binaries" 

echo "Downloading Crusader binary arm64"
mkdir -p "arm-binaries"
wget -O - -q "https://github.com/Zoxc/crusader/releases/download/v$CRUSADER_VERSION/Crusader-macOS-ARM-64-bit.tar.gz" | \
  tar -xz -f - -C "arm-binaries" 

# create a universal binary from the x86 and arm binaries
echo "Creating a universal binary"
lipo -create -output crusader-univ \
   arm-binaries/Crusader-macOS-ARM-64-bit/crusader-gui \
   x86-binaries/Crusader-macOS-X86-64-bit/crusader-gui 

# === Start building the new application bundle ===

# Remove the previous Crusader.app bundle so we can rebuild anew
rm -rf "$APP_BUNDLE_NAME"
mkdir -p "$APP_BUNDLE_NAME/Contents/MacOS"
mkdir -p "$APP_BUNDLE_NAME/Contents/Resources/"

# Copy the CFBundleExecutable script that launches Crusader & make it executable
echo "Copy crusader-univ to the app bundle"
cp ./crusader-univ "$APP_BUNDLE_NAME/Contents/MacOS/"
# cp run-crusader.sh "$APP_BUNDLE_NAME/Contents/MacOS/run-crusader.sh"
chmod +x "$APP_BUNDLE_NAME/Contents/MacOS/crusader-univ"

# Copy the .icns file
echo "Adding .icns"
cp Crusader.icns "$APP_BUNDLE_NAME/Contents/Resources"

# Copy the Info.plist & update its strings
echo "Updating Info.plist"
cp Info.plist "$APP_BUNDLE_NAME/Contents"
INFO_STRING="Crusader $CRUSADER_VERSION"
plist_path="$APP_BUNDLE_NAME/Contents/Info.plist"
python3 ./update_plist.py "$plist_path" "$INFO_STRING" "$NEW_VERSION"

# Clean up

rm -rf x86-binaries
rm -rf arm-binaries
rm crusader-univ

echo "Done"
