{
  cargoHash,
  openssl_1_1,
  pkg-config,
  rustPlatform,
  source,
}:
rustPlatform.buildRustPackage {
  inherit (source) pname src version;
  buildInputs = [
    openssl_1_1
  ];
  cargoLock.lockFile = ./Cargo.lock;
  cargoPatches = [
    ./Cargo.lock.patch
  ];
  nativeBuildInputs = [
    pkg-config
  ];
}
