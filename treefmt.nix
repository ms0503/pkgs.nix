{ ... }:
{
  programs = {
    nixfmt.enable = true;
    rustfmt = {
      edition = "2021";
      enable = true;
    };
    shellcheck.enable = true;
    shfmt = {
      enable = true;
      indent_size = 4;
    };
    stylua.enable = true;
    taplo.enable = true;
  };
  settings.formatter.nixfmt.excludes = [
    "_sources/generated.nix"
  ];
}
