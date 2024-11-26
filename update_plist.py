 # Update the plist:
 # - CFBundleShortVersionString
 # - CFBundleVersion

 # Run with: 
 # python3 update_plist.py path/to/Info.plist "FinderInfoString" "CFBundleVersion"

import plistlib
import sys

def update_version(plist_path, new_version, bundle_version):
    # Load the plist
    with open(plist_path, 'rb') as f:
        plist = plistlib.load(f)

    # Update CFBundleVersion & CFBundleShortVersionString
    plist['CFBundleShortVersionString'] = new_version
    plist['CFBundleVersion'] = bundle_version

    # Write back the updated plist
    with open(plist_path, 'wb') as f:
        plistlib.dump(plist, f)

    # print(f"Updated {plist_path} with Version: {new_version}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: script.py <path_to_plist> <new_version> <CFBundleVersion>")
        sys.exit(1)

    plist_path = sys.argv[1]
    new_version = sys.argv[2]
    bundle_version = sys.argv[3]

    update_version(plist_path, new_version, bundle_version)
