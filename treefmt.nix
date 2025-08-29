{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];
  perSystem =
    { inputs', pkgs, ... }:
    {
      treefmt = {
        programs = {
          mdformat = {
            enable = true;
            package = pkgs.mdformat.withPlugins (
              ps: with ps; [
                mdformat-gfm
              ]
            );
            settings = {
              end-of-line = "lf";
              number = true;
              wrap = 80;
            };
          };
          nixfmt.enable = true;
          rustfmt = {
            edition = "2024";
            enable = true;
            package = inputs'.fenix.packages.latest.rustfmt;
          };
          shellcheck.enable = true;
          shfmt = {
            enable = true;
            indent_size = 4;
          };
          stylua.enable = true;
          taplo.enable = true;
        };
        settings.formatter = {
          nixfmt.excludes = [
            "_sources/generated.nix"
          ];
          shellcheck.excludes = [
            "**/.envrc"
            ".envrc"
          ];
        };
      };
    };
}
