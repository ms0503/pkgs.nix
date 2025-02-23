{
  callPackage,
  dockerTools,
  fetchFromGitHub,
  fetchgit,
  fetchurl,
  lib,
  linkFarm,
  ...
}:
let
  packages = rec {
    alcom = callPackage ./alcom {
      cargoHash = "sha256-Ph6QZW21JYQJgrUecN+MklWuY51iKC2glPEdgxw+3r8=";
      npmHash = "sha256-lWQPBILZn8VGoILfEY2bMxGaBL2ALGbvcT5RqanTNyY=";
      source = sources.alcom;
    };
    blender3 = callPackage ./blender3 {
      assetsHash = "sha256-C+4ewC4BTbyUp/EV8eqKgJSXMz5cRFOY1NBR3xO93rE=";
      sourceHash = "sha256-ysP42g7OFuvB1leAuWfyUxHL/yZXx4TdlGDCrsT4lnw=";
      version = "3.6.19";
    };
    discord-canary-wayland = callPackage ./discord-canary-wayland { };
    git-vrc = callPackage ./git-vrc {
      cargoHash = "sha256-SPnqrHsrQ5RIL+WzE3/hcuX6R3QF5KZmOGPmFNkBpZc=";
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
      cargoHash = "sha256-iucI4/iMF+uXRlnMttobu4xo3IQXq7tGiSSN8eCrLM0=";
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
    zifu = callPackage ./zifu {
      cargoHash = "sha256-mBXXftmwEKq1ClgLwrWzKE5PdV6WnMCso4fso4ANS+k=";
      source = sources.zifu;
    };
  };
  sources = import ../_sources/generated.nix {
    inherit
      dockerTools
      fetchFromGitHub
      fetchgit
      fetchurl
      ;
  };
in
packages
// {
  default = linkFarm "all" (lib.mapAttrsToList (name: path: { inherit name path; }) packages);
}
