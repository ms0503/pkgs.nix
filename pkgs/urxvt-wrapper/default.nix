{ stdenvNoCC }:
stdenvNoCC.mkDerivation {
  installPhase = ''
    install -dm755 "$out/bin"
    install -Dm755 urxvt-wrapper.sh "$out/bin/urxvt-wrapper"
  '';
  meta.description = "URxvt wrapper to use daemon mode easily";
  name = "urxvt-wrapper";
  src = ./.;
}
