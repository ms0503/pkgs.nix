_: {
  perSystem =
    {
      inputs',
      lib,
      pkgs,
      pkgsB3d3,
      self',
      system,
      ...
    }:
    let
      inherit (pkgs)
        alcom
        callPackage
        dockerTools
        fetchFromGitHub
        fetchgit
        fetchurl
        makeRustPlatform
        ;
      sources = import ../_sources/generated.nix {
        inherit
          dockerTools
          fetchFromGitHub
          fetchgit
          fetchurl
          ;
      };
    in
    {
      packages =
        let
          rustPlatform = makeRustPlatform {
            cargo = inputs'.fenix.packages.latest.toolchain;
            rustc = inputs'.fenix.packages.latest.toolchain;
          };
        in
        {
          alcom = builtins.warn "github:ms0503/pkgs.nix#alcom is deprecated. Please use nixpkgs#alcom instead." alcom;
          discord-canary-wayland = callPackage ./discord-canary-wayland { };
          ds4pairer = callPackage ./ds4pairer {
            source = sources.ds4pairer;
          };
          fakevrchat = callPackage ./fakevrchat {
            hash = "sha256-wlSAYYQq7YUZA9/XB0B6jWY8krieDNQaiScSVhNNVZ4=";
          };
          git-vrc = callPackage ./git-vrc {
            inherit rustPlatform;
            cargoHash = "sha256-/vO8xkD0uW0kqF8RzvAw2/TAvmDI5N8GZD0f6S6lY+M=";
            source = sources.git-vrc;
          };
          microsoft-edge-dev = callPackage ./microsoft-edge-dev { };
          microsoft-edge-dev-wayland = callPackage ./microsoft-edge-dev-wayland {
            inherit (self'.packages) microsoft-edge-dev;
          };
          microsoft-edit = callPackage ./microsoft-edit {
            inherit rustPlatform;
            cargoHash = "sha256-ceAaaR+N03Dq2MHYel4sHDbbYUOr/ZrtwqJwhaUbC2o=";
            source = sources.microsoft-edit;
          };
          noto-fonts-cjk-sans-non-variable = callPackage ./noto-fonts-cjk-sans-non-variable {
            source = sources.noto-cjk-sans;
          };
          noto-fonts-cjk-serif-non-variable = callPackage ./noto-fonts-cjk-serif-non-variable {
            source = sources.noto-cjk-serif;
          };
          noto-fonts-non-variable = callPackage ./noto-fonts-non-variable {
            source = sources.noto-fonts;
          };
          proton-ge-rtsp-bin = callPackage ./proton-ge-rtsp-bin {
            source = sources.proton-ge-rtsp-bin;
          };
          slack-wayland = callPackage ./slack-wayland { };
          spotify-wayland = callPackage ./spotify-wayland { };
          unzip-unicode = callPackage ./unzip-unicode { };
          urxvt-wrapper = callPackage ./urxvt-wrapper { };
          walland = callPackage ./walland {
            source = sources.walland;
          };
          wezimgcat-wrapper = callPackage ./wezimgcat-wrapper {
            inherit rustPlatform;
          };
          zifu = callPackage ./zifu {
            inherit rustPlatform;
            cargoHash = "sha256-MKnhEqa8u8yg7fEc3GdPX63kIMl0FPOFg8FOSViLPhg=";
            source = sources.zifu;
          };
        }
        // lib.optionalAttrs (pkgs.stdenv.isLinux) {
          blender3 = pkgsB3d3.callPackage ./blender3 {
            hash = "sha256-vFZjV6EDWARObGf0mWw/cQfILbWQtDQsML/bjyc4UJk=";
            version = "3.6.23";
          };
          blender3-cpu = self'.packages.blender3.override {
            cudaSupport = false;
            hipSupport = false;
          };
          blender3-gpu = self'.packages.blender3.override {
            cudaSupport = true;
            hipSupport = true;
          };
        };
    };
}
