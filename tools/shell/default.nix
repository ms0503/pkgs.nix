{
  imports = [
    ./treefmt.nix
    ./git-hooks.nix
  ];
  perSystem =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
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
}
