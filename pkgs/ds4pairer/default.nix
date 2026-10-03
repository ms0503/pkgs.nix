{
  cmake,
  hidapi,
  lib,
  ninja,
  pkg-config,
  source,
  stdenv,
}:
stdenv.mkDerivation {
  inherit (source) pname src;
  buildInputs = [
    hidapi
  ];
  installPhase = ''
    runHook preInstall
    install -Dm555 bin/ds4pairer "$out/bin/ds4pairer"
    runHook postInstall
  '';
  meta = {
    description = "A tool for viewing and setting the bluetooth address a DualShock 4 controller is currently paired with";
    downloadPage = "https://github.com/paulstraw/ds4pairer";
    homepage = "https://github.com/paulstraw/ds4pairer";
    license = lib.licenses.mit;
    mainProgram = "ds4pairer";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];
  patches = [
    ./add-new-product-id.patch
    ./bump-cmake-minimum-required.patch
    ./fix-find-hidapi.patch
    ./fix-missing-ctype.h.patch
  ];
  version = source.date;
}
