{
  callPackage,
  dockerTools,
  fetchFromGitHub,
  fetchgit,
  fetchurl,
  ...
}:
let
  sources = import ../_sources/generated.nix {
    inherit
      dockerTools
      fetchFromGitHub
      fetchgit
      fetchurl
      ;
  };
in
rec {
  alcom = callPackage ./alcom {
    cargoHash = "sha256-MImKIdRZ0xNqmpmqukFQiSCty8V6DRP+P2fCHULTxJI=";
    npmHash = "sha256-jg0F7V59pvONPNQGqbt+lIFZwK+OE248hiUe+Of4eFg=";
    source = sources.alcom;
  };
  blender3 = callPackage ./blender3 {
    assetsHash = "sha256-C+4ewC4BTbyUp/EV8eqKgJSXMz5cRFOY1NBR3xO93rE=";
    sourceHash = "sha256-ysP42g7OFuvB1leAuWfyUxHL/yZXx4TdlGDCrsT4lnw=";
    version = "3.6.19";
  };
  git-vrc = callPackage ./git-vrc {
    cargoHash = "sha256-SPnqrHsrQ5RIL+WzE3/hcuX6R3QF5KZmOGPmFNkBpZc=";
    source = sources.git-vrc;
  };
  microsoft-edge-dev = callPackage ./microsoft-edge-dev { };
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
}
