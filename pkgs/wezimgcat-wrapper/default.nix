{
  imagemagick,
  lib,
  rustPlatform,
}:
let
  cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
in
rustPlatform.buildRustPackage {
  inherit (cargoToml.package) version;
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
  pname = cargoToml.package.name;
  src = ./.;
  useFetchCargoVendor = true;
}
