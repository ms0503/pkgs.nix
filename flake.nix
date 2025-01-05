{
  inputs = {
    fenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/fenix";
    };
    flake-compat.url = "github:edolstra/flake-compat";
    git-hooks = {
      inputs = {
        flake-compat.follows = "flake-compat";
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
    {
      fenix,
      git-hooks,
      nixpkgs,
      self,
      treefmt-nix,
      ...
    }:
    let
      allSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs allSystems;
    in
    {
      checks = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        in
        {
          formatting = treefmtEval.config.build.check self;
          pre-commit-check = git-hooks.lib.${system}.run {
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
              treefmt = {
                enable = true;
                package = treefmtEval.config.build.wrapper;
              };
              yamlfmt.enable = true;
              yamllint.enable = true;
            };
            src = ./.;
          };
        }
      );
      devShells = forAllSystems (
        system:
        let
          packages =
            preCommitCheck.enabledPackages
            ++ (with pkgs; [
              nvfetcher
            ]);
          pkgs = import nixpkgs { inherit system; };
          preCommitCheck = self.checks.${system}.pre-commit-check;
        in
        {
          default = pkgs.mkShell {
            inherit packages;
            inherit (preCommitCheck) shellHook;
          };
        }
      );
      formatter = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        in
        treefmtEval.config.build.wrapper
      );
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [
              fenix.overlays.default
            ];
          };
        in
        import ./pkgs pkgs
      );
    };
}
