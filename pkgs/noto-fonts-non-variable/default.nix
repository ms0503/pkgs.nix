{
  noto-fonts,
  source,
  stdenvNoCC,
}:
let
  weights = "{Bold,BoldItalic,Italic,Light,LightItalic,Regular}";
in
stdenvNoCC.mkDerivation {
  inherit (noto-fonts) meta;
  inherit (source) pname src version;
  installPhase = ''
    runHook preInstall
    local out_dir=$out/share/fonts/truetype/noto
    install -Dm444 -t "$out_dir" fonts/{NotoSans,NotoSerif}/unhinted/*/*-${weights}.ttf
    install -Dm444 -t "$out_dir" fonts/{NotoSans,NotoSerif}/hinted/*/*-${weights}.ttf
    runHook postInstall
  '';
}
