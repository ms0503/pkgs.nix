# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  ds4pairer = {
    pname = "ds4pairer";
    version = "24b6f6194e67270e94781c6b1211a4a830735fe9";
    src = fetchFromGitHub {
      owner = "paulstraw";
      repo = "ds4pairer";
      rev = "24b6f6194e67270e94781c6b1211a4a830735fe9";
      fetchSubmodules = false;
      sha256 = "sha256-JZxEQhl+f2xGK/5nu3+6j/k06SER6u56cF6W9F8SoRY=";
    };
    date = "2023-03-28";
  };
  git-vrc = {
    pname = "git-vrc";
    version = "b0ca3bf7da90099a02181df8880af022c6fc0320";
    src = fetchFromGitHub {
      owner = "anatawa12";
      repo = "git-vrc";
      rev = "b0ca3bf7da90099a02181df8880af022c6fc0320";
      fetchSubmodules = true;
      sha256 = "sha256-UKS7i0tyaeScaubTTusdwZfmojQXwj+EDqxfw8vQkgA=";
    };
    date = "2025-06-18";
  };
  microsoft-edit = {
    pname = "microsoft-edit";
    version = "1.2.0";
    src = fetchurl {
      url = "https://github.com/microsoft/edit/archive/refs/tags/v1.2.0.tar.gz";
      sha256 = "sha256-5Lpv8b/s/v8kkjBvWFDHFL9Q/9s8w7tb46qYconyQP4=";
    };
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
    version = "2025.06.01";
    src = fetchurl {
      url = "https://github.com/notofonts/notofonts.github.io/archive/refs/tags/noto-monthly-release-2025.06.01.tar.gz";
      sha256 = "sha256-6QrvVUu0hM0AQue2DNKfOwtg6xv1CNaSY0J7xog+Cqc=";
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
    version = "d1c9dae35e7125e642f93e6acfee2682e801b627";
    src = fetchFromGitHub {
      owner = "Golim";
      repo = "walland";
      rev = "d1c9dae35e7125e642f93e6acfee2682e801b627";
      fetchSubmodules = false;
      sha256 = "sha256-5SiLbLz3N3D/Fvu42zJy1QUQjArkzabwBo5pYP7DbcA=";
    };
    date = "2025-05-21";
  };
  zifu = {
    pname = "zifu";
    version = "447684211b6f3bb2eb0938c84a14d89c86e533b3";
    src = fetchFromGitHub {
      owner = "tats-u";
      repo = "zifu";
      rev = "447684211b6f3bb2eb0938c84a14d89c86e533b3";
      fetchSubmodules = false;
      sha256 = "sha256-4gtIPpLzI9ufrtwx0+W72uEfzrva6IE+koEUxbBBHJ8=";
    };
    date = "2024-11-14";
  };
}
