{
  inputs = {
    awww-bing = {
      inputs = {
        fenix.follows = "fenix";
        flake-compat.follows = "";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "";
        ms0503-lib.follows = "ms0503-lib";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "";
      };
      url = "github:ms0503/awww-bing";
    };
    colortool = {
      inputs = {
        fenix.follows = "fenix";
        flake-compat.follows = "";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "";
        ms0503-lib.follows = "ms0503-lib";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "";
      };
      url = "github:ms0503/colortool";
    };
    fenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/fenix";
    };
    flake-compat = {
      flake = false;
      url = "github:NixOS/flake-compat";
    };
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs";
      url = "github:hercules-ci/flake-parts";
    };
    generatehex = {
      inputs = {
        fenix.follows = "fenix";
        flake-compat.follows = "";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "";
        ms0503-lib.follows = "ms0503-lib";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "";
      };
      url = "github:ms0503/generatehex";
    };
    getcodepoint = {
      inputs = {
        fenix.follows = "fenix";
        flake-compat.follows = "";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "";
        ms0503-lib.follows = "ms0503-lib";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "";
      };
      url = "github:ms0503/getcodepoint";
    };
    getemoji = {
      inputs = {
        fenix.follows = "fenix";
        flake-compat.follows = "";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "";
        ms0503-lib.follows = "ms0503-lib";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "";
      };
      url = "github:ms0503/getemoji";
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
        git-hooks.follows = "";
        ms0503-lib.follows = "ms0503-lib";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "";
      };
      url = "github:ms0503/mc-mod-downloader";
    };
    ms0503-lib = {
      inputs = {
        flake-compat.follows = "";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "";
      };
      url = "github:ms0503/lib.nix";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-blender3.url = "github:NixOS/nixpkgs/nixos-25.05";
    skel = {
      inputs = {
        fenix.follows = "fenix";
        flake-compat.follows = "";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "";
        ms0503-lib.follows = "ms0503-lib";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "";
      };
      url = "github:ms0503/skel";
    };
    systems = {
      flake = false;
      url = "github:nix-systems/default";
    };
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
    unicodeescape = {
      inputs = {
        fenix.follows = "fenix";
        flake-compat.follows = "";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "";
        ms0503-lib.follows = "ms0503-lib";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "";
      };
      url = "github:ms0503/unicodeescape";
    };
    urlencode = {
      inputs = {
        fenix.follows = "fenix";
        flake-compat.follows = "";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "";
        ms0503-lib.follows = "ms0503-lib";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "";
      };
      url = "github:ms0503/urlencode";
    };
  };
  nixConfig = {
    experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
    substituters = [
      "https://cache.nixos.org"
      "https://ms0503.cachix.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-unfree.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "ms0503.cachix.org-1:Cc2mXpepZr7O9aFcRj5jq3mIcvdUPp85sLFuQj+IKbM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
    ];
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
              config = {
                allowUnfree = true;
                permittedInsecurePackages = [
                  "ilmbase-2.5.10"
                  "openexr-2.5.10"
                ];
              };
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
