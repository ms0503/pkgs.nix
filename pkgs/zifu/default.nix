{
  cargoHash,
  lib,
  mold,
  rustPlatform,
  source,
}:
rustPlatform.buildRustPackage {
  inherit cargoHash;
  inherit (source) pname src version;
  RUSTFLAGS = "-Clink-arg=-fuse-ld=mold";
  meta = {
    description = "Tool that fixes file names in ZIP archives (make them UTF-8)";
    downloadPage = "https://github.com/tats-u/zifu/releases";
    license = lib.licenses.mit;
    mainProgram = "zifu";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
  nativeBuildInputs = [
    mold
  ];
  useFetchCargoVendor = true;
}
