{
  lib,
  mold,
  openssl_1_1,
  pkg-config,
  rustPlatform,
  source,
}:
rustPlatform.buildRustPackage {
  inherit (source) pname src version;
  RUSTFLAGS = "-Clink-arg=-fuse-ld=mold";
  buildInputs = [
    openssl_1_1
  ];
  cargoLock.lockFile = ./Cargo.lock;
  cargoPatches = [
    ./Cargo.lock.patch
  ];
  meta = {
    description = "Spotify for the terminal written in Rust 🚀";
    downloadPage = "https://github.com/Rigellute/spotify-tui/releases";
    homepage = "https://github.com/Rigellute/spotify-tui";
    license = lib.licenses.mit;
    mainProgram = "spt";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
  nativeBuildInputs = [
    mold
    pkg-config
  ];
  useFetchCargoVendor = true;
}
