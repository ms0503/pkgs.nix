{
  lib,
  mold,
  rustPlatform,
}:
let
  inherit (lib) cleanSource cleanSourceWith;
  cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
in
rustPlatform.buildRustPackage {
  inherit (cargoToml.package) version;
  RUSTFLAGS = "-Clink-arg=-fuse-ld=mold";
  cargoLock.lockFile = ./Cargo.lock;
  meta = {
    description = "A tool for converting between plain text and URL-encoded text";
    license = lib.licenses.mit;
    mainProgram = "urlencode";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
  nativeBuildInputs = [
    mold
  ];
  pname = cargoToml.package.name;
  src = cleanSourceWith {
    filter = name: _: name != "default.nix";
    src = cleanSource ./.;
  };
}
