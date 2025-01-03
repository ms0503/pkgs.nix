{ callPackage, ... }:
{
  alcom = callPackage ./alcom { };
  microsoft-edge-dev = callPackage ./microsoft-edge-dev { };
  proton-ge-rtsp-bin = callPackage ./proton-ge-rtsp-bin { };
  unzip-unicode = callPackage ./unzip-unicode { };
  urxvt-wrapper = callPackage ./urxvt-wrapper { };
  zifu = callPackage ./zifu { };
}
