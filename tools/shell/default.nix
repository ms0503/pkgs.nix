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
        packages = builtins.concatLists [
          config.pre-commit.settings.enabledPackages
          (config.treefmt.build.programs |> lib.attrValues)
          (with pkgs; [
            nvfetcher
          ])
        ];
        shellHook = ''
          ${config.pre-commit.shellHook}
        '';
      };
    };
}
