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
{
  alcom = callPackage ./alcom {
    cargoHash = "sha256-MImKIdRZ0xNqmpmqukFQiSCty8V6DRP+P2fCHULTxJI=";
    npmHash = "sha256-jg0F7V59pvONPNQGqbt+lIFZwK+OE248hiUe+Of4eFg=";
    source = sources.alcom;
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
