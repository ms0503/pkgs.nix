_: {
  perSystem =
    {
      inputs',
      lib,
      pkgs,
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
        stdenv
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
        }
        // rec {
          blender3 = callPackage ./blender3 (
            lib.optionalAttrs (!stdenv.isDarwin) {
              Cocoa = null;
              CoreGraphics = null;
              ForceFeedback = null;
              OpenAL = null;
              OpenGL = null;
            }
          );
          discord-canary-wayland = callPackage ./discord-canary-wayland { };
          ds4pairer = callPackage ./ds4pairer {
            source = sources.ds4pairer;
          };
          git-vrc = callPackage ./git-vrc {
            inherit rustPlatform;
            cargoHash = "sha256-/vO8xkD0uW0kqF8RzvAw2/TAvmDI5N8GZD0f6S6lY+M=";
            source = sources.git-vrc;
          };
          microsoft-edge-dev = callPackage ./microsoft-edge-dev { };
          microsoft-edge-dev-wayland = callPackage ./microsoft-edge-dev-wayland {
            inherit microsoft-edge-dev;
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
          unity-vrc-2019 = callPackage ./unity-vrc-2019 {
            inherit noto-fonts-cjk-sans-non-variable;
          };
          unity-vrc-2022 = callPackage ./unity-vrc-2022 {
            inherit noto-fonts-cjk-sans-non-variable;
          };
          unity-vrc-2022-old = callPackage ./unity-vrc-2022-old {
            inherit noto-fonts-cjk-sans-non-variable;
          };
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
        };
    };
}
