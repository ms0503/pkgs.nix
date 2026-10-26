{
  depsHash,
  dictionaries ? [ ],
  dictionaryProfile ? "daily",
  fcitx5,
  gettext,
  lib,
  mozkey,
  nixosTests,
  pkg-config,
  powershell,
  python3,
  sources,
  stdenv,
  stdenvNoCC,
  unzip,
  writableTmpDirAsHomeHook,
}:
let
  inherit (mozkey') bazel;
  inherit (sources.mozkey) version;
  bazelArgs = mozkey'.bazelCommonArgs ++ [
    "--action_env=CPLUS_INCLUDE_PATH=${includePath}"
    "--action_env=C_INCLUDE_PATH=${includePath}"
    "--action_env=LIBRARY_PATH=${libraryPath}"
    "unix/fcitx5:fcitx5-mozc.so"
    "unix/icons"
  ];
  buildInputs = [
    fcitx5
  ];
  includePath = lib.makeIncludePath buildInputs;
  libraryPath = lib.makeLibraryPath buildInputs;
  mozkey' = mozkey.override {
    inherit dictionaries dictionaryProfile;
  };
  nativeBuildInputs = [
    bazel
    gettext
    pkg-config
    powershell
    python3
    unzip
    writableTmpDirAsHomeHook
  ];
  pname = "fcitx5-mozkey";
  src = stdenvNoCC.mkDerivation {
    inherit (sources.mozkey) src;
    installPhase = ''
      runHook preInstall
      cp -r . "$out"
      cp -r "${sources.fcitx5-mozc.src}/scripts" "$out/scripts"
      cp -r "${sources.fcitx5-mozc.src}/src/unix/fcitx5" "$out/src/unix/fcitx5"
      printf '%s\n' \
        "" \
        "# Fcitx 5" \
        "pkg_config_repository(" \
        "    name = \"fcitx5\"," \
        "    packages = [" \
        "        \"Fcitx5Module\"," \
        "        \"Fcitx5Core\"," \
        "    ]," \
        ")" \
        >> "$out/src/MODULE.bazel"
      runHook postInstall
    '';
    name = "source";
    sourceRoot = "mozkey-${version}";
  };
  vendorDeps = mozkey'.mkVendorDeps {
    inherit
      bazelArgs
      buildInputs
      nativeBuildInputs
      pname
      src
      version
      ;
    hash = depsHash;
  };
in
stdenv.mkDerivation {
  inherit
    buildInputs
    nativeBuildInputs
    pname
    src
    version
    ;
  __structuredAttrs = true;
  buildPhase = ''
    runHook preBuild
    bazel build \
      --lockfile_mode=error \
      --vendor_dir=vendor_dir \
      ${lib.escapeShellArgs bazelArgs}
    runHook postBuild
  '';
  env = {
    USER = "nixbld";
    USE_BAZEL_VERSION = bazel.version;
  };
  installPhase = ''
    runHook preInstall
    PREFIX=$out ../scripts/install_fcitx5_bazel
    install -Dm444 ../LICENSE "$out/share/licenses/$pname/LICENSE"
    iconsDir=$out/share/icons/hicolor/scalable/apps
    mkdir -p "$iconsDir"
    unzip -q bazel-bin/unix/icons.zip -d icons
    install -Dm444 icons/mozc.svg "$iconsDir/org.fcitx.Fcitx5.fcitx_mozc.svg"
    ln -s org.fcitx.Fcitx5.fcitx_mozc.svg "$iconsDir/fcitx_mozc.svg"
    for icon in \
      alpha_full \
      alpha_half \
      direct \
      hiragana \
      katakana_full \
      katakana_half \
      dictionary \
      properties \
      tool
    do
      install -Dm444 "icons/$icon.svg" "$iconsDir/org.fcitx.Fcitx5.fcitx_mozc_$icon.svg"
      ln -s "org.fcitx.Fcitx5.fcitx_mozc_$icon.svg" "$iconsDir/fcitx_mozc_$icon.svg"
    done
    runHook postInstall
  '';
  meta = {
    description = "Fcitx 5 module for Mozkey";
    homepage = "https://github.com/koyasi777/mozkey";
    license = with lib.licenses; [
      asl20
      bsd3
      mit
      naist-2003
      publicDomain
      unicode-30
    ];
    platforms = lib.platforms.linux;
  };
  passthru = {
    inherit vendorDeps;
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
      inherit (nixosTests) fcitx5;
    };
  };
  postPatch = ''
    patchShebangs --build scripts
    cd src
    ${mozkey'.setupBazelVendor vendorDeps}
    substituteInPlace config.bzl \
      --replace-fail "/usr/lib/mozc" "${mozkey'}/lib/mozc"
  '';
  preBuild = ''
    install -Dm444 "${mozkey'.dic}/dist/dictionary/koyasi-syntax-guard-debug.tsv" ../dist/dictionary/koyasi-syntax-guard-debug.tsv
    install -Dm444 "${mozkey'.dic}/src/data/dictionary_koyasi/generated/profiled/koyasi-syntax-guard.txt" data/dictionary_koyasi/generated/profiled/koyasi-syntax-guard.txt
    install -Dm444 "${mozkey'.dic}/src/data/dictionary_koyasi/generated/profiled/mozcdic-ut-daily.txt" data/dictionary_koyasi/generated/profiled/mozcdic-ut-daily.txt
    install -Dm444 "${mozkey'.dic}/src/data/dictionary_koyasi/generated/profiled/mozcdic-ut-personal-names-daily.txt" data/dictionary_koyasi/generated/profiled/mozcdic-ut-personal-names-daily.txt
  '';
  strictDeps = true;
}
