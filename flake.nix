{
  inputs = {
    fenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/fenix";
    };
    flake-compat.url = "github:edolstra/flake-compat";
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
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
  };
  outputs =
    inputs@{
      fenix,
      flake-parts,
      git-hooks,
      nixpkgs,
      treefmt-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        git-hooks.flakeModule
        treefmt-nix.flakeModule
      ];
      perSystem =
        { config, system, ... }:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [
              fenix.overlays.default
            ];
          };
        in
        {
          _module.args.pkgs = pkgs;
          devShells.default =
            let
              packages = with pkgs; [
                nvfetcher
              ];
            in
            pkgs.mkShell {
              inherit packages;
              shellHook = ''
                ${config.pre-commit.installationScript}
              '';
            };
          packages = import ./pkgs pkgs;
          pre-commit = {
            check.enable = true;
            settings = {
              hooks = {
                actionlint.enable = true;
                check-json.enable = true;
                check-toml.enable = true;
                editorconfig-checker = {
                  enable = true;
                  excludes = [
                    "_sources"
                    "flake.lock"
                    "pkgs/alcom/deps.json"
                  ];
                };
                markdownlint.enable = true;
                yamlfmt.enable = true;
                yamllint.enable = true;
              };
              src = ./.;
            };
          };
          treefmt = import ./treefmt.nix;
        };
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    };
}
