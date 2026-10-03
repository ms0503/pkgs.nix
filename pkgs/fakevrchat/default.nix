{
  compat-client-install-path ? "~",
  compat-data-path ? "${compat-client-install-path}/steamapps/compatdata/438100",
  lib,
  proton-path ? "${compat-client-install-path}/steamapps/common/Proton - Experimental/proton",
  stdenvNoCC,
  steam-run,
  vrchat-exe-path ? "${compat-client-install-path}/steamapps/common/VRChat",
}:
assert lib.assertMsg (
  compat-client-install-path != ""
) "at least, you must specify compat-client-install-path";
stdenvNoCC.mkDerivation {
  buildPhase = ''
    runHook preBuild
    sed -i FakeVRChat.exe \
      -e 's;^\(PARAM_PROTON_PATH=\)$;\1"${proton-path}";' \
      -e 's;^\(PARAM_STEAM_COMPAT_CLIENT_INSTALL_PATH=\)$;\1"${compat-client-install-path}";' \
      -e 's;^\(PARAM_STEAM_COMPAT_DATA_PATH=\)$;\1"${compat-data-path}";' \
      -e 's;^\(PARAM_STEAM_RUN=\)$;\1"${steam-run}/bin/steam-run";' \
      -e 's;^\(PARAM_VRCHAT_EXE_PATH=\)$;\1"${vrchat-exe-path}";'
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    install -Dm555 FakeVRChat.exe "$out/bin/FakeVRChat.exe"
    runHook postInstall
  '';
  meta = {
    description = "VRChat wrapper for offline world testing on Linux";
    license = lib.licenses.mit;
    mainProgram = "";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
  pname = "fakevrchat";
  src = ./FakeVRChat.exe;
  unpackPhase = ''
    runHook preUnpack
    cp "$src" FakeVRChat.exe
    runHook postUnpack
  '';
  version = "1.0.0";
}
