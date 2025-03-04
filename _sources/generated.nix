# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  git-vrc = {
    pname = "git-vrc";
    version = "601fe2881631542b263501b52ac01dad99dc6ede";
    src = fetchFromGitHub {
      owner = "anatawa12";
      repo = "git-vrc";
      rev = "601fe2881631542b263501b52ac01dad99dc6ede";
      fetchSubmodules = true;
      sha256 = "sha256-zR8yau7K4QZLjZ/MsqC7UwrGklr4QC+fPJTHRQ451uI=";
    };
    date = "2024-06-19";
  };
  noto-cjk-sans = {
    pname = "noto-cjk-sans";
    version = "2.004";
    src = fetchurl {
      url = "https://github.com/notofonts/noto-cjk/releases/download/Sans2.004/03_NotoSansCJK-OTC.zip";
      sha256 = "sha256-Uo9OGyX/O62wMhs40BXZVMTA3pJseDDvUOShlI9qPu0=";
    };
  };
  noto-cjk-serif = {
    pname = "noto-cjk-serif";
    version = "2.003";
    src = fetchurl {
      url = "https://github.com/notofonts/noto-cjk/releases/download/Serif2.003/04_NotoSerifCJKOTC.zip";
      sha256 = "sha256-x27Y/Ukc6YGC7GQwI4uQoeq+qIV8fbZOkDfvo44ZijE=";
    };
  };
  noto-fonts = {
    pname = "noto-fonts";
    version = "2025.03.01";
    src = fetchurl {
      url = "https://github.com/notofonts/notofonts.github.io/archive/refs/tags/noto-monthly-release-2025.03.01.tar.gz";
      sha256 = "sha256-eApDwsT2B6PnGSuI0UAWQLDAQfbC16YxPDAVf1Nnx3E=";
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
  spotify-tui = {
    pname = "spotify-tui";
    version = "0.25.0";
    src = fetchurl {
      url = "https://github.com/Rigellute/spotify-tui/archive/refs/tags/v0.25.0.tar.gz";
      sha256 = "sha256-nW+pmOYlzv+VilNVtDeasWS6dldRQ6e21diutsNtcKc=";
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
