{
  cmake,
  engine,
  fcitx5,
  kdePackages,
  libxkbcommon,
  mold,
  pkg-config,
  source,
  stdenv,
}:
stdenv.mkDerivation {
  inherit (source) src version;
  buildInputs = [
    fcitx5
    libxkbcommon
  ];
  cmakeDir = "../karukan-im/fcitx5-addon";
  cmakeFlags = [
    "-DCMAKE_LINKER_TYPE=MOLD"
  ];
  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    mold
    pkg-config
  ];
  patches = [
    ./replace-engine-with-prebuilt.patch
  ];
  pname = "${source.pname}-im";
  postPatch = ''
    substituteInPlace karukan-im/fcitx5-addon/CMakeLists.txt \
      --replace-fail "@engine@" "${engine}"
  '';
}
