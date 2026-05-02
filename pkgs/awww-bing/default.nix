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
    description = "awww wrapper for getting image from Bing Wallpaper";
    license = lib.licenses.mit;
    mainProgram = "awww-bing";
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
