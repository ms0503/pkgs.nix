# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}:
{
  alcom = {
    pname = "alcom";
    version = "gui-v1.0.0";
    src = fetchFromGitHub {
      owner = "vrc-get";
      repo = "vrc-get";
      rev = "gui-v1.0.0";
      fetchSubmodules = true;
      sha256 = "sha256-bfpDb/V/SfVaT4OBSrONpzwYn6Sh6gP2iDZsr/wX2Pw=";
    };
  };
  proton-ge-rtsp-bin = {
    pname = "proton-ge-rtsp-bin";
    version = "GE-Proton9-22-rtsp17";
    src = fetchurl {
      url = "https://github.com/SpookySkeletons/proton-ge-rtsp/releases/download/GE-Proton9-22-rtsp17/GE-Proton9-22-rtsp17.tar.gz";
      sha256 = "sha256-lk51oeLkBjBJ8NFVAmAxHihXCGS0eKczoYUrPan5pQs=";
    };
  };
  walland = {
    pname = "walland";
    version = "d50ed2b5c76dc6585c629f4d65a819bd53397ab9";
    src = fetchFromGitHub {
      owner = "Golim";
      repo = "walland";
      rev = "d50ed2b5c76dc6585c629f4d65a819bd53397ab9";
      fetchSubmodules = false;
      sha256 = "sha256-x5zaiaPjwa/MHHIwmO4rXZR1Olt4d2QuaBqwk4Hvo8k=";
    };
    date = "2024-09-23";
  };
  zifu = {
    pname = "zifu";
    version = "1.1.0";
    src = fetchurl {
      url = "https://github.com/tats-u/zifu/archive/refs/tags/v1.1.0.tar.gz";
      sha256 = "sha256-Llg2z83Qq6lD0Yppmyb0z7XKIoijLB3ukepOj6BEH4w=";
    };
  };
}
