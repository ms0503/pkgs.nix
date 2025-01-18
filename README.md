# ms0503 packages

This repository contains packages that are out-dated or not included in
nixpkgs.

## Package List

- alcom
  - Description:
    Experimental GUI application to manage VRChat Unity Projects
  - Source:
    [github:vrc-get/vrc-get][vrc-get]
- blender3
  - Description:
    3D Creation/Animation/Publishing System
  - Inherit:
    [nixpkgs]
- microsoft-edge-dev
  - Description:
    Web browser from Microsoft, weekly build
  - Source:
    packages.microsoft.com
  - Note:
    Unfree
- proton-ge-rtsp-bin
  - Description:
    Compatibility tool for Steam Play based on Wine and additional components.  
    (This is intended for use in the \`programs.steam.extraCompatPackages\`
    option only.)
  - Source:
    [github:SpookySkeletons/proton-ge-rtsp][proton-ge-rtsp]
- unzip-unicode
  - Description:
    Extraction utility for archives compressed in .zip format, with Unicode
    support
  - Source:
    [sourceforge:infozip][infozip]
- urxvt-wrapper
  - Description:
    URxvt wrapper to use daemon mode easily
  - Source:
    none
- walland
  - Description:
    Set as wallpaper on Wayland the picture of the day of different sources
    using hyprpaper or other backends
  - Source:
    [github:Golim/walland][walland]
- zifu
  - Description:
    Tool that fixes file names in ZIP archives (make them UTF-8)
  - Source:
    [github:tats-u/zifu][zifu]

[infozip]: https://sourceforge.net/projects/infozip
[nixpkgs]: https://github.com/NixOS/nixpkgs
[proton-ge-rtsp]: https://github.com/SpookySkeletons/proton-ge-rtsp
[vrc-get]: https://github.com/vrc-get/vrc-get
[walland]: https://github.com/Golim/walland
[zifu]: https://github.com/tats-u/zifu
