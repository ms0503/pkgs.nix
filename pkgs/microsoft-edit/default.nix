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
    description = "A simple editor for simple needs";
    downloadPage = "https://github.com/microsoft/edit/releases";
    homepage = "https://github.com/microsoft/edit";
    license = lib.licenses.mit;
    mainProgram = "edit";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
  nativeBuildInputs = [
    mold
  ];
  useFetchCargoVendor = true;
}
