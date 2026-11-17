{
  cargoHash,
  clang,
  cmake,
  libclang,
  mold,
  oniguruma,
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
    oniguruma
    openssl
  ];
  cargoBuildFlags = [
    "-p"
    "karukan-cli"
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
  pname = "${source.pname}-cli";
}
