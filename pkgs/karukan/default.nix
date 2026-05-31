{
  callPackage,
  cargoHash,
  lib,
  rustPlatform,
  source,
  symlinkJoin,
}:
let
  cli = callPackage ./cli.nix {
    inherit cargoHash rustPlatform source;
  };
  engine = callPackage ./engine.nix {
    inherit cargoHash rustPlatform source;
  };
  im = callPackage ./im.nix {
    inherit engine source;
  };
in
symlinkJoin {
  inherit (source) pname version;
  meta = {
    description = "Japanese Input Method System for Linux, Neural Kana-Kanji Conversion Engine + fcitx5 IME";
    downloadPage = "https://github.com/togatoga/karukan/releases";
    homepage = "https://github.com/togatoga/karukan";
    license = with lib.licenses; [
      asl20
      mit
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
  paths = [
    cli
    im
  ];
}
