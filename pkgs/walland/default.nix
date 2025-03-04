{
  lib,
  python3Packages,
  source,
}:
let
  inherit (python3Packages)
    beautifulsoup4
    buildPythonApplication
    curl-cffi
    lxml
    requests
    setuptools
    ;
in
buildPythonApplication {
  inherit (source) pname src;
  build-system = [
    setuptools
  ];
  dependencies = [
    beautifulsoup4
    curl-cffi
    lxml
    requests
  ];
  meta = {
    description = "Set as wallpaper on Wayland the picture of the day of different sources using hyprpaper or other backends";
    homepage = "https://github.com/Golim/walland";
    license = lib.licenses.mit;
    mainProgram = "walland";
  };
  patches = [
    ./add-setup-py.patch
  ];
  version = source.date;
}
