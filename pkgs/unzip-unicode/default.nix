{ unzip }:
unzip.overrideAttrs (
  _: prev: {
    meta = {
      inherit (prev.meta) mainProgram;
      description = "${prev.meta.description}, with Unicode support";
    };
    patches = prev.patches ++ [
      ./20-unzip60-alt-iconv-utf8.patch
      ./30-fix-code-pages.patch
    ];
    pname = "unzip-unicode";
    preConfigure = ''
      ${prev.preConfigure}
      sed -i -E 's/CF="(.*)"/CF="\1 -DUNICODE_SUPPORT -DUTF8_MAYBE_NATIVE"/' unix/Makefile
    '';
  }
)
