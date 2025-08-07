{
  compat-client-install-path ? "~",
  compat-data-path ? "${compat-client-install-path}/steamapps/compatdata/438100",
  fetchurl,
  hash,
  lib,
  proton-path ? "${compat-client-install-path}/steamapps/common/Proton - Experimental/proton",
  stdenv,
  steam-run,
  vrchat-exe-path ? "${compat-client-install-path}/steamapps/common/VRChat",
}:
assert lib.assertMsg (
  compat-client-install-path != ""
) "at least, you must specify compat-client-install-path";
stdenv.mkDerivation {
  buildPhase = ''
    runHook preBuild
    g++ -O2 -o FakeVRChat FakeVRChat.cpp
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    install -Dm555 FakeVRChat "$out/opt/FakeVRChat/bin/FakeVRChat"
    cat <<EOF >"$out/opt/FakeVRChat/bin/FakeVRChat.exe"
    #!/usr/bin/env bash
    exec "${steam-run}/bin/steam-run" "$out/opt/FakeVRChat/bin/FakeVRChat" "$@"
    EOF
    chmod 0555 "$out/opt/FakeVRChat/bin/FakeVRChat.exe"
    runHook postInstall
  '';
  meta = {
    description = ''The fake "VRChat.exe" for running offline test of VRChat World on GNU/Linux'';
    downloadPage = "https://software.tlfoxhuman.net/categories/small-code/FakeVRChat.exe";
    homepage = "https://software.tlfoxhuman.net";
    license = lib.licenses.mit;
    mainProgram = "";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
  patchPhase = ''
    runHook prePatch
    sed -i FakeVRChat.cpp \
      -e 's|^	std::string compat_data_path .*$|	std::string compat_data_path = "${compat-data-path}";|' \
      -e 's|^	std::string compat_client_install_path .*$|	std::string compat_client_install_path = "${compat-client-install-path}";|' \
      -e 's|^	std::string proton_path .*$|	std::string proton_path = "${proton-path}";|' \
      -e 's|^	std::string vrchat_exe_path .*$|	std::string vrchat_exe_path = "${vrchat-exe-path}";|'
    runHook postPatch
  '';
  patches = [
    ./replace-2f-with-slash-instead-of-bslash.patch
  ];
  pname = "fakevrchat";
  src = fetchurl {
    inherit hash;
    url = "https://software.tlfoxhuman.net/categories/small-code/FakeVRChat.exe/FakeVRChat.cpp";
  };
  unpackPhase = ''
    runHook preUnpack
    cp "$src" FakeVRChat.cpp
    runHook postUnpack
  '';
  version = "1.0.3";
}
