# ms0503 packages

This repository contains packages that are out-dated or not included in nixpkgs.

## Package List

- blender3
  - Description: 3D Creation/Animation/Publishing System
  - Source: [blender]
- blender3-cpu
  - Description: 3D Creation/Animation/Publishing System, without GPU supports
  - Inherit: .#blender3
- blender3-gpu
  - Description: 3D Creation/Animation/Publishing System, with GPU supports
  - Inherit: .#blender3
- discord-canary-wayland
  - Description: All-in-one cross-platform voice and text chat for gamers,
    including Wayland support
  - Inherit: [nixpkgs]#discord-canary
- ds4pairer
  - Description: A tool for viewing and setting the bluetooth address a
    DualShock 4 controller is currently paired with
  - Source: [github:paulstraw/ds4pairer]
- fakevrchat
  - Description: VRChat wrapper for offline world testing on Linux
  - Source: none
- git-vrc
  - Description: A command line extension for git to reduce meaningless diff on
    git of VRC project
  - Source: [github:anatawa12/git-vrc]
- microsoft-edge-dev
  - Description: Web browser from Microsoft, weekly build
  - Source: packages.microsoft.com
  - Note: Unfree
- microsoft-edge-dev-wayland
  - Description: Web browser from Microsoft, weekly build, including Wayland
    support
  - Inherit: .#microsoft-edge-dev
  - Note: Unfree
- microsoft-edit
  - Description: A simple editor for simple needs
  - Source: [github:microsoft/edit]
- noto-fonts-cjk-sans-non-variable
  - Description: Beautiful and free fonts for CJK languages, non-variable
    version
  - Source: [github:notofonts/noto-cjk]
- noto-fonts-cjk-serif-non-variable
  - Description: Beautiful and free fonts for CJK languages, non-variable
    version
  - Source: [github:notofonts/noto-cjk]
- noto-fonts-non-variable
  - Description: Beautiful and free fonts for many languages, non-variable
    version
  - Source: [github:notofonts/notofonts.github.io]
- proton-ge-rtsp-bin
  - Description: Compatibility tool for Steam Play based on Wine and additional
    components\
    (This is intended for use in the \`programs.steam.extraCompatPackages\`
    option only)
  - Source: [github:SpookySkeletons/proton-ge-rtsp]
- slack-wayland
  - Description: Desktop client for Slack, including Wayland support
  - Inherit: [nixpkgs]#slack
- spotify-wayland
  - Description: Play music from the Spotify music service, including Wayland
    support
  - Inherit: [nixpkgs]#spotify
- unzip-unicode
  - Description: Extraction utility for archives compressed in .zip format, with
    Unicode support
  - Inherit: [nixpkgs]#unzip
  - Note: Unfree
- urxvt-wrapper
  - Description: URxvt wrapper to use daemon mode easily
  - Source: none
- walland
  - Description: Set as wallpaper on Wayland the picture of the day of different
    sources using hyprpaper or other backends
  - Source: [github:Golim/walland]
- wezimgcat-wrapper
  - Description: WezTerm's imgcat wrapper for unsupported images
  - Source: none
- zifu
  - Description: Tool that fixes file names in ZIP archives (make them UTF-8)
  - Source: [github:tats-u/zifu]

[blender]: https://www.blender.org
[github:anatawa12/git-vrc]: https://github.com/anatawa12/git-vrc
[github:golim/walland]: https://github.com/Golim/walland
[github:microsoft/edit]: https://github.com/microsoft/edit
[github:notofonts/noto-cjk]: https://github.com/notofonts/noto-cjk
[github:notofonts/notofonts.github.io]: https://github.com/notofonts/notofonts.github.io
[github:paulstraw/ds4pairer]: https://github.com/paulstraw/ds4pairer
[github:spookyskeletons/proton-ge-rtsp]: https://github.com/SpookySkeletons/proton-ge-rtsp
[github:tats-u/zifu]: https://github.com/tats-u/zifu
[nixpkgs]: https://github.com/NixOS/nixpkgs
