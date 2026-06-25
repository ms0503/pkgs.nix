{ inputs, self, ... }:
{
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
      cargoHashes =
        (self.lib.cargoHashes {
          inherit system;
        }).hashes;
      externalPackages = [
        "awww-bing"
        "colortool"
        "generatehex"
        "getcodepoint"
        "getemoji"
        "mc-mod-downloader"
        "skel"
        "unicodeescape"
        "urlencode"
      ];
      generateExternalPackages = packages: lib.genAttrs packages (name: inputs'.${name}.packages.default);
      myLib = inputs.ms0503-lib.lib;
      rustPlatform = makeRustPlatform {
        inherit (inputs'.fenix.packages.latest) cargo rustc;
      };
      sources =
        import ../_sources/generated.nix {
          inherit
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
    {
      packages = {
        alcom = builtins.warn "github:ms0503/pkgs.nix#alcom is deprecated. Please use nixpkgs#alcom instead." alcom;
        dic-nico-intersection-pixiv = callPackage ./dic-nico-intersection-pixiv {
          source = sources.dic-nico-intersection-pixiv;
        };
        discord-canary-wayland = callPackage ./discord-canary-wayland { };
        ds4pairer = callPackage ./ds4pairer {
          source = sources.ds4pairer;
        };
        fakevrchat = callPackage ./fakevrchat { };
        fcitx5-mozkey = callPackage ./fcitx5-mozkey {
          inherit (self'.packages) dic-nico-intersection-pixiv mozkey;
          source = sources.mozkey;
        };
        git-vrc = callPackage ./git-vrc {
          inherit rustPlatform;
          cargoHash = cargoHashes.git-vrc;
          source = sources.git-vrc;
        };
        karukan = callPackage ./karukan {
          inherit rustPlatform;
          cargoHash = cargoHashes.karukan;
          source = sources.karukan;
        };
        microsoft-edge-dev = callPackage ./microsoft-edge-dev { };
        microsoft-edge-dev-wayland = callPackage ./microsoft-edge-dev-wayland {
          inherit (self'.packages) microsoft-edge-dev;
        };
        microsoft-edit = callPackage ./microsoft-edit {
          inherit rustPlatform;
          cargoHash = cargoHashes.microsoft-edit;
          source = sources.microsoft-edit;
        };
        mozkey = callPackage ./mozkey {
          inherit (self'.packages) dic-nico-intersection-pixiv;
          source = sources.mozkey;
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
          inherit myLib rustPlatform;
        };
        zifu = callPackage ./zifu {
          inherit rustPlatform;
          cargoHash = cargoHashes.zifu;
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
      }
      // generateExternalPackages externalPackages;
    };
}
