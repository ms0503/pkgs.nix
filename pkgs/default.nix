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
    cargoHash = "sha256-v9aNXafFj2vMM5VlKNfroK0mMi6021XUkoqkAXw2Trg=";
    npmHash = "sha256-QAUoz/mzF9aDvkILKX3rxkYUC+VmJeRVjG8vJ/b0Dho=";
    source = sources.alcom;
  };
  microsoft-edge-dev = callPackage ./microsoft-edge-dev { };
  proton-ge-rtsp-bin = callPackage ./proton-ge-rtsp-bin {
    source = sources.proton-ge-rtsp-bin;
  };
  unzip-unicode = callPackage ./unzip-unicode { };
  urxvt-wrapper = callPackage ./urxvt-wrapper { };
  zifu = callPackage ./zifu {
    cargoHash = "sha256-mBXXftmwEKq1ClgLwrWzKE5PdV6WnMCso4fso4ANS+k=";
    source = sources.zifu;
  };
}
