{ stdenvNoCC }:
stdenvNoCC.mkDerivation {
  installPhase = ''
    install -dm755 "$out/bin"
    install -Dm755 urxvt-wrapper.sh "$out/bin/urxvt-wrapper"
  '';
  name = "urxvt-wrapper";
  src = ./.;
}
