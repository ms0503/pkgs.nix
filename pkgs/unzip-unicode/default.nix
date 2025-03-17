{ fetchurl, unzip }:
unzip.overrideAttrs (
  _: prev: {
    meta = {
      inherit (prev.meta) mainProgram;
      description = "${prev.meta.description}, with Unicode support";
    };
    patches = prev.patches ++ [
      (fetchurl {
        hash = "sha256-525tbsmc0sg5cwBR6EHCh3o0Cg3kqPseT6PQZnmWpBw=";
        name = "20-unzip60-alt-iconv-utf8.patch";
        url = "https://git.launchpad.net/ubuntu/+source/unzip/plain/debian/patches/20-unzip60-alt-iconv-utf8.patch?id=4b84f6f7b2bb169583ab3a6f542528f1c2c0ad7b";
      })
      (fetchurl {
        hash = "sha256-wcotXp0z+QjrRyGlT6Unxa/7i9shecIzQ3eWZb5+TdM=";
        name = "30-fix-code-pages.patch";
        url = "https://git.launchpad.net/ubuntu/+source/unzip/plain/debian/patches/30-fix-code-pages.patch?id=4b84f6f7b2bb169583ab3a6f542528f1c2c0ad7b";
      })
    ];
    pname = "unzip-unicode";
    preConfigure = ''
      ${prev.preConfigure}
      sed -i -E 's/CF="(.*)"/CF="\1 -DUNICODE_SUPPORT -DUTF8_MAYBE_NATIVE"/' unix/Makefile
    '';
  }
)
