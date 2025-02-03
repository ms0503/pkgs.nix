{
  cargoHash,
  lib,
  rustPlatform,
  source,
}:
rustPlatform.buildRustPackage {
  inherit cargoHash;
  inherit (source) pname src;
  meta = {
    description = "A command line extension for git to reduce meaningless diff on git of VRC project";
    downloadPage = "https://github.com/anatawa12/git-vrc";
    license = with lib.licenses; [
      apache
      mit
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
  version = source.date;
}
