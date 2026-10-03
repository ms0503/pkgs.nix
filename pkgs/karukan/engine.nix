{
  cargoHash,
  clang,
  cmake,
  libclang,
  mold,
  openssl,
  pkg-config,
  rustPlatform,
  source,
}:
rustPlatform.buildRustPackage {
  inherit cargoHash;
  inherit (source) src version;
  LIBCLANG_PATH = "${libclang.lib}/lib/libclang.so";
  RUSTFLAGS = "-Clink-arg=-fuse-ld=mold";
  buildInputs = [
    openssl
  ];
  cargoBuildFlags = [
    "-p"
    "karukan-im"
  ];
  nativeBuildInputs = [
    clang
    cmake
    mold
    pkg-config
  ];
  patches = [
    ./disable-engine-backend-tests.patch
  ];
  pname = "${source.pname}-engine";
}
