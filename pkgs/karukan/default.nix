{
  callPackage,
  cargoHash,
  cmake,
  fcitx5,
  kdePackages,
  lib,
  libxkbcommon,
  mold,
  pkg-config,
  rustPlatform,
  source,
  stdenv,
}:
let
  engine = callPackage ./engine.nix {
    inherit
      cargoHash
      rustPlatform
      source
      ;
  };
in
stdenv.mkDerivation {
  inherit (source) pname src version;
  buildInputs = [
    fcitx5
    libxkbcommon
  ];
  cmakeDir = "../karukan-im/fcitx5-addon";
  cmakeFlags = [
    "-DCMAKE_LINKER_TYPE=MOLD"
  ];
  meta = {
    description = "Japanese Input Method System for Linux, Neural Kana-Kanji Conversion Engine + fcitx5 IME";
    downloadPage = "https://github.com/togatoga/karukan/releases";
    homepage = "https://github.com/togatoga/karukan";
    license = with lib.licenses; [
      asl20
      mit
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    mold
    pkg-config
  ];
  passthru = {
    inherit engine;
  };
  patches = [
    ./replace-engine-with-prebuilt.patch
  ];
  postPatch = ''
    substituteInPlace karukan-im/fcitx5-addon/CMakeLists.txt \
      --replace-fail "@engine@" "${engine}"
  '';
}
