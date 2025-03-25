_: {
  perSystem =
    { pkgs, ... }:
    let
      inherit (pkgs)
        callPackage
        dockerTools
        fetchFromGitHub
        fetchgit
        fetchurl
        git
        ;
      sources = import ../_sources/generated.nix {
        inherit
          dockerTools
          fetchFromGitHub
          fetchgit
          fetchurl
          ;
      };
    in
    {
      packages = rec {
        alcom = callPackage ./alcom {
          cargoHash = "sha256-Ph6QZW21JYQJgrUecN+MklWuY51iKC2glPEdgxw+3r8=";
          npmHash = "sha256-lWQPBILZn8VGoILfEY2bMxGaBL2ALGbvcT5RqanTNyY=";
          source =
            let
              version = "1.0.1";
            in
            {
              inherit version;
              pname = "alcom";
              src = fetchFromGitHub {
                hash = "sha256-+6BI67exjXvr/P8jgbsyjb7b+oV8Uf5hQVHSVhYQicU=";
                leaveDotGit = true;
                owner = "vrc-get";
                postFetch = ''
                  cd "$out"
                  ${git}/bin/git rev-parse HEAD >commit_hash.txt
                  rm -rf .git
                '';
                repo = "vrc-get";
                rev = "gui-v${version}";
              };
            };
        };
        blender3 = callPackage ./blender3 {
          assetsHash = "sha256-C+4ewC4BTbyUp/EV8eqKgJSXMz5cRFOY1NBR3xO93rE=";
          sourceHash = "sha256-ysP42g7OFuvB1leAuWfyUxHL/yZXx4TdlGDCrsT4lnw=";
          version = "3.6.19";
        };
        discord-canary-wayland = callPackage ./discord-canary-wayland { };
        ds4pairer = callPackage ./ds4pairer {
          source = sources.ds4pairer;
        };
        git-vrc = callPackage ./git-vrc {
          cargoHash = "sha256-/vO8xkD0uW0kqF8RzvAw2/TAvmDI5N8GZD0f6S6lY+M=";
          source = sources.git-vrc;
        };
        microsoft-edge-dev = callPackage ./microsoft-edge-dev { };
        microsoft-edge-dev-wayland = callPackage ./microsoft-edge-dev-wayland {
          inherit microsoft-edge-dev;
        };
        noto-fonts-cjk-sans-non-variable = callPackage ./noto-fonts-cjk-sans-non-variable {
          source = sources.noto-cjk-sans;
        };
        noto-fonts-cjk-serif-non-variable = callPackage ./noto-fonts-cjk-serif-non-variable {
          source = sources.noto-cjk-serif;
        };
        noto-fonts-non-variable = callPackage ./noto-fonts-non-variable {
          source = sources.noto-fonts;
        };
        proton-ge-rtsp-bin = callPackage ./proton-ge-rtsp-bin {
          source = sources.proton-ge-rtsp-bin;
        };
        slack-wayland = callPackage ./slack-wayland { };
        spotify-tui = callPackage ./spotify-tui {
          source = sources.spotify-tui;
        };
        spotify-wayland = callPackage ./spotify-wayland { };
        unity-vrc-2019 = callPackage ./unity-vrc-2019 {
          inherit noto-fonts-cjk-sans-non-variable;
        };
        unity-vrc-2022 = callPackage ./unity-vrc-2022 {
          inherit noto-fonts-cjk-sans-non-variable;
        };
        unity-vrc-2022-old = callPackage ./unity-vrc-2022-old {
          inherit noto-fonts-cjk-sans-non-variable;
        };
        unzip-unicode = callPackage ./unzip-unicode { };
        urxvt-wrapper = callPackage ./urxvt-wrapper { };
        walland = callPackage ./walland {
          source = sources.walland;
        };
        wezimgcat-wrapper = callPackage ./wezimgcat-wrapper { };
        zifu = callPackage ./zifu {
          cargoHash = "sha256-IjR1uplTbfaX0VGkv1vTtafOTGCLQYd+4yPmj1wuw9Q=";
          source = sources.zifu;
        };
      };
    };
}
