{
  nixosTests,
  noto-fonts-cjk-serif,
  source,
  stdenvNoCC,
  unar,
}:
stdenvNoCC.mkDerivation {
  inherit (noto-fonts-cjk-serif) meta;
  inherit (source) pname src version;
  installPhase = ''
    local out_dir=$out/share/fonts/opentype/noto-cjk
    install -Dm444 -t "$out_dir" *-04_NotoSerifCJKOTC/OTC/*.ttc
  '';
  nativeBuildInputs = [
    unar
  ];
  passthru.tests.noto-fonts = nixosTests.noto-fonts;
  unpackPhase = ''
    runHook preUnpack
    unar "$src"
    runHook postUnpack
  '';
}
