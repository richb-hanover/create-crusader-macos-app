# Create Crusader.app - a clickable macOS app bundle

The [Crusader application](https://github.com/Zoxc/crusader)
is currently distributed as a binary that opens a
Terminal window.
This is surprising to users and doesn't provide any value
because all the information that would appear in the Terminal
is also logged within Crusader.

The _create-crusader-macos-app.sh_ script solves those problems
by creating a macOS application that can be downloaded
and double-clicked.
That bundle also hides the Terminal window.

**Provisos:** One-time actions to use the app

* Double-clicking the app launches Crusader as desired, but
  this app bundle is not signed.
  The Finder will produce an "unverified developer" warning.
  Go to **System Preference -> Security** to accept and open the app.

## How it works

The script bundles
both the x86 and arm64 (Apple Silicon)
`crusader-gui` binaries,
the required _Info.plist_ file,
an icon for the application,
and the necessary startup script.
It also sets the Finder version info to
the string "Crusader VERSION". 

The build script runs on any Linux/macOS computer.
In addition to the shell, it requires `python3`.
It is not tied to any macOS-specific utilities.

The script downloads current versions of all the resources
from canonical URLs and places them
in the proper directory of the bundle.
The final layout is:

```
Crusader.app/
├── Contents/
    ├── MacOS/
    │   └── run-crusader.sh
    ├── Resources/
    │   │── Crusader.icns
    │   |── arm64
    |   |   └── Crusader-macOS-ARM-64-bit
    │   |       └── crusader-gui
    │   └── x86
    |   |   └── Crusader-macOS-X86-64-bit
    │   |       └── crusader-gui
    └── Info.plist

```

_Note:_ The _CFBundleVersion.txt_ file contains the current 
value placed in the `CFBundleVersion` key of the _Info.plist_ file.
This is incremented each time the app gets rebuilt.
This helps the Finder on the destination machine to recognize that
it should re-read the meta-data (including the Info string).
If multiple machines are building the app, be sure to push to the main
repo and pull before building on another build machine. 

## Usage

To use the script:

1. Edit these constants
  (APP\_BUNDLE\_NAME, CRUSADER\_VERSION)
  to match the software versions you are bundling.
2. Run these commands

  ```
  cd this-repo
  sh ./create-crusader-macos-app.sh
  ```
3. The Crusader.app bundle is built in the top level
  of the directory. 
  Immediately after being built, the bundle's icon
  may not appear in the Finder.
  **Get info...** usually forces the Finder to update it.

## Testing

The result has received minimal testing
and seems to work as expected on:
macos 10.15 (Catalina - Intel),
macOS 12.7.6 (Intel),
macOS 14.6.1 (arm64, Apple Silicon),
macOS 15.1 (Apple Silicon), and
macOS 15.0.1 (Intel)

## icns generation

There are several steps to produce the `.icns` file.
The [png-to-icns]()
script takes a 1024x1024 pixel PNG file and creates
the `.icns` file with all the various size icons.

But... the default Apple logo "style" is a rounded rectangle
inset from the outer bounds by about 10%.
The _Crusader-in-rrect.svg_ file is a good template.
To use it:

* Open the _Crusader-in-rrect.svg_ file in Inkscape
  (or other vector drawing program).
* Notice the black rounded rectangle surrounding the icon.
  It is about 90% of the height/width of the full icon,
  and has rounded corners.
* Update the icon image inside the rounded-rectangld as needed.
* Change the stroke for the rounded rectangle to "X" (none)
  to make it invisible.
* Save the file as `.svg`
* Export as PNG: Select the "Page" tab, and ensure that the
  border is a checkerboard, indicating that it's transparent.

Copy the saved `.png` file to the _png-to-icns_ folder.
Use this command: `sh ./png-to-icns.sh -i path-to-png`
Rename the resulting `.icns` file, and move back to the
desired folder.
