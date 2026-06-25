{
  lib,
  rustPlatform,
  sources,
}:
{
  get-hash =
    pkg:
    rustPlatform.fetchCargoVendor {
      inherit (sources.${pkg}) src;
      hash = lib.fakeHash;
    };
  hashes = {
    git-vrc = "sha256-/vO8xkD0uW0kqF8RzvAw2/TAvmDI5N8GZD0f6S6lY+M=";
    karukan = "sha256-fn9TjaIuYy4z65iUZxPntLacj7vIEpVgr2HrGkyTGag=";
    microsoft-edit = "sha256-r7AR6Mf13UUeooPV5/8gyp7HvmOeSaOJNotWWqU10SQ=";
    zifu = "sha256-bQMFznDsAsF2KhTryry2eLImtBdDS6/27/DB4OzSejI=";
  };
}
