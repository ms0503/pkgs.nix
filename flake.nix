{
  inputs = {
    fenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/fenix";
    };
    flake-compat = {
      flake = false;
      url = "github:edolstra/flake-compat";
    };
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs";
      url = "github:hercules-ci/flake-parts";
    };
    git-hooks = {
      inputs = {
        flake-compat.follows = "";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:cachix/git-hooks.nix";
    };
    mc-mod-downloader = {
      inputs = {
        fenix.follows = "fenix";
        flake-compat.follows = "";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
      url = "github:ms0503/mc-mod-downloader";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-blender3.url = "github:NixOS/nixpkgs/nixos-25.05";
    systems = {
      flake = false;
      url = "github:nix-systems/default";
    };
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
  };
  outputs =
    inputs@{
      flake-parts,
      nixpkgs,
      nixpkgs-blender3,
      systems,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./treefmt.nix
        ./git-hooks.nix
        ./pkgs
      ];
      perSystem =
        {
          config,
          lib,
          pkgs,
          system,
          ...
        }:
        {
          _module.args = {
            pkgs = import nixpkgs {
              inherit system;
              config = {
                allowUnfree = true;
                permittedInsecurePackages = [
                  "openssl-1.1.1w"
                ];
              };
            };
            pkgsB3d3 = import nixpkgs-blender3 {
              inherit system;
              config.allowUnfree = true;
            };
          };
          devShells.default = pkgs.mkShell {
            packages =
              config.pre-commit.settings.enabledPackages
              ++ lib.attrValues config.treefmt.build.programs
              ++ (with pkgs; [
                nvfetcher
              ]);
            shellHook = ''
              ${config.pre-commit.shellHook}
            '';
          };
        };
      systems = import systems;
    };
}
