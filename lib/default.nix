{ withSystem, ... }:
{
  flake.lib = {
    cargoHashes =
      { system }:
      withSystem system (
        { inputs', pkgs, ... }:
        let
          inherit (pkgs) lib;
          rustPlatform = pkgs.makeRustPlatform {
            inherit (inputs'.fenix.packages.latest) cargo rustc;
          };
          sources =
            import ../_sources/generated.nix {
              inherit (pkgs)
                dockerTools
                fetchFromGitHub
                fetchgit
                fetchurl
                ;
            }
            |> builtins.mapAttrs (
              name: value:
              value
              // lib.optionalAttrs (value ? date) {
                version = value.date;
              }
            );
        in
        import ./cargo-hashes.nix {
          inherit lib rustPlatform sources;
        }
      );
  };
}
