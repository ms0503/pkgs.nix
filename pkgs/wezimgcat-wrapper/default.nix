{
  imagemagick,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  buildInputs = [
    imagemagick
  ];
  cargoLock.lockFile = ./Cargo.lock;
  meta = {
    description = "WezTerm's imgcat wrapper for unsupported images";
    license = lib.licenses.mit;
    mainProgram = "wezimgcat-wrapper";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
  pname = "wezimgcat-wrapper";
  src = ./.;
  useFetchCargoVendor = true;
  version = "0.1.0";
}
