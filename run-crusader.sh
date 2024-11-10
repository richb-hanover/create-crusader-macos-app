#! /bin/sh

# Startup script to launch the Crusader app

# Set the path to the proper Crusader binary:
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    PREFIX="$(dirname "$0")/../Resources/x86"
elif [ "$ARCH" = "arm64" ]; then
    PREFIX="$(dirname "$0")/../Resources/arm64"
else
    echo "Unknown architecture: $ARCH"
fi

# launch the proper binary; 
# redirect to /dev/null to prevent the Terminal from opening

"$PREFIX/Crusader-macOS-X86-64-bit/crusader-gui" > /dev/null 2>&1 &
