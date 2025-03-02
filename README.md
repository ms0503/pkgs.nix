# ms0503 packages

This repository contains packages that are out-dated or not included in
nixpkgs.

## Package List

- alcom
  - Description:
    Experimental GUI application to manage VRChat Unity Projects
  - Source:
    [github:vrc-get/vrc-get]
- blender3
  - Description:
    3D Creation/Animation/Publishing System
  - Inherit:
    [nixpkgs]\#blender
- discord-canary-wayland
  - Description:
    All-in-one cross-platform voice and text chat for gamers, including Wayland support
  - Inherit:
    [nixpkgs]\#discord-canary
- git-vrc
  - Description:
    A command line extension for git to reduce meaningless diff on git of VRC project
  - Source:
    [github:anatawa12/git-vrc]
- microsoft-edge-dev
  - Description:
    Web browser from Microsoft, weekly build
  - Source:
    packages.microsoft.com
  - Note:
    Unfree
- microsoft-edge-dev-wayland
  - Description:
    Web browser from Microsoft, weekly build, including Wayland support
  - Inherit:
    .\#microsoft-edge-dev
  - Note:
    Unfree
- noto-fonts-cjk-sans-non-variable
  - Description:
    Beautiful and free fonts for CJK languages, non-variable version
  - Source:
    [github:notofonts/noto-cjk]
- noto-fonts-cjk-serif-non-variable
  - Description:
    Beautiful and free fonts for CJK languages, non-variable version
  - Source:
    [github:notofonts/noto-cjk]
- noto-fonts-non-variable
  - Description:
    Beautiful and free fonts for many languages, non-variable version
  - Source:
    [github:notofonts/notofonts.github.io]
- proton-ge-rtsp-bin
  - Description:
    Compatibility tool for Steam Play based on Wine and additional components.  
    (This is intended for use in the \`programs.steam.extraCompatPackages\`
    option only.)
  - Source:
    [github:SpookySkeletons/proton-ge-rtsp]
- slack-wayland
  - Description:
    Desktop client for Slack, including Wayland support
  - Inherit:
    [nixpkgs]\#slack
- spotify-tui
  - Description:
    Spotify for the terminal written in Rust 🚀
  - Source:
    [github:Rigellute/spotify-tui]
- spotify-wayland
  - Description:
    Play music from the Spotify music service, including Wayland support
  - Inherit:
    [nixpkgs]\#spotify
- unity-vrc-2019
  - Description:
    Unity for VRChat (2019.4.31f1)
  - Source:
    netstorage.unity3d.com
    new-translate.unity3d.jp
  - Note:
    Unfree
- unity-vrc-2022
  - Description:
    Unity for VRChat (2022.3.22f1)
  - Source:
    netstorage.unity3d.com
    new-translate.unity3d.jp
  - Note:
    Unfree
- unity-vrc-2022-old
  - Description:
    Unity for VRChat (2022.3.6f1)
  - Source:
    netstorage.unity3d.com
    new-translate.unity3d.jp
  - Note:
    Unfree
- unzip-unicode
  - Description:
    Extraction utility for archives compressed in .zip format, with Unicode
    support
  - Source:
    [sf:infozip]
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
    [github:Golim/walland]
- wezimgcat-wrapper
  - Description:
    WezTerm's imgcat wrapper for unsupported images
  - Source:
    none
- zifu
  - Description:
    Tool that fixes file names in ZIP archives (make them UTF-8)
  - Source:
    [github:tats-u/zifu]

[github:Golim/walland]: https://github.com/Golim/walland
[github:Rigellute/spotify-tui]: https://github.com/Rigellute/spotify-tui
[github:SpookySkeletons/proton-ge-rtsp]: https://github.com/SpookySkeletons/proton-ge-rtsp
[github:anatawa12/git-vrc]: https://github.com/anatawa12/git-vrc
[github:notofonts/noto-cjk]: https://github.com/notofonts/noto-cjk
[github:notofonts/notofonts.github.io]: https://github.com/notofonts/notofonts.github.io
[github:tats-u/zifu]: https://github.com/tats-u/zifu
[github:vrc-get/vrc-get]: https://github.com/vrc-get/vrc-get
[nixpkgs]: https://github.com/NixOS/nixpkgs
[sf:infozip]: https://sourceforge.net/projects/infozip
