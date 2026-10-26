# Packaging this package is supported by OpenAI Codex. Thanks!
{
  bazel_9,
  copyDesktopItems,
  depsHash,
  dic-nico-intersection-pixiv,
  dictionaries ? [ ],
  dictionaryProfile ? "daily",
  glib,
  ibus,
  lib,
  libglvnd,
  makeDesktopItem,
  merge-ut-dictionaries,
  mozc,
  mozcdic-ut-alt-cannadic,
  mozcdic-ut-edict2,
  mozcdic-ut-jawiki,
  mozcdic-ut-neologd,
  mozcdic-ut-personal-names,
  mozcdic-ut-place-names,
  mozcdic-ut-skk-jisyo,
  mozcdic-ut-sudachidict,
  pkg-config,
  powershell,
  python3,
  qt6,
  source,
  stdenv,
  unzip,
  withIbus ? false,
  writableTmpDirAsHomeHook,
  xdg-utils,
}:
let
  inherit (mozc) bazelCommonArgs mkVendorDeps setupBazelVendor;
  bazel = bazel_9;
  bazelArgs =
    bazelCommonArgs
    ++ [
      "--action_env=CPLUS_INCLUDE_PATH=${includePath}"
      "--action_env=C_INCLUDE_PATH=${includePath}"
      "--action_env=LIBRARY_PATH=${libraryPath}"
      "gui/tool:mozc_tool"
      "server:mozc_server"
      "unix/emacs:mozc_emacs_helper"
    ]
    ++ lib.optionals withIbus [
      "renderer/qt:mozc_renderer"
      "unix/ibus:ibus_mozc"
    ];
  buildInputs = [
    glib
    ibus
    libglvnd
    qt6.qtbase
  ];
  dictionaries' =
    dictionaries
    ++ (
      if (dictionaryProfile == "daily") then
        [
          mozcdic-ut-place-names
          mozcdic-ut-sudachidict
        ]
      else if (dictionaryProfile == "rich") then
        [
          mozcdic-ut-jawiki
          mozcdic-ut-neologd
          mozcdic-ut-personal-names
          mozcdic-ut-place-names
          mozcdic-ut-sudachidict
        ]
      else if (dictionaryProfile == "max") then
        [
          mozcdic-ut-alt-cannadic
          mozcdic-ut-edict2
          mozcdic-ut-jawiki
          mozcdic-ut-neologd
          mozcdic-ut-personal-names
          mozcdic-ut-place-names
          mozcdic-ut-skk-jisyo
          mozcdic-ut-sudachidict
        ]
      else
        throw "dictionaryProfile must be 'daily', 'rich' or 'max'"
    );
  includePath = lib.makeIncludePath buildInputs;
  libraryPath = lib.makeLibraryPath buildInputs;
  nativeBuildInputs = [
    bazel
    copyDesktopItems
    pkg-config
    powershell
    python3
    qt6.wrapQtAppsHook
    unzip
    writableTmpDirAsHomeHook
  ];
  ut-dictionary = merge-ut-dictionaries.override {
    dictionaries = dictionaries';
  };
  ut-dictionary-personal-names = merge-ut-dictionaries.override {
    dictionaries = [
      mozcdic-ut-personal-names
    ];
  };
  ut-dictionary-sample = merge-ut-dictionaries.override {
    dictionaries = [
      mozcdic-ut-place-names
      mozcdic-ut-sudachidict
    ];
  };
  vendorDeps = mkVendorDeps {
    inherit nativeBuildInputs;
    inherit (source) pname src version;
    bazelArgs = bazelArgs ++ [
      "renderer/qt:mozc_renderer"
      "unix/emacs:mozc_emacs_helper"
      "unix/ibus:ibus_mozc"
    ];
    buildInputs = buildInputs ++ [
      glib
      ibus
    ];
    hash = depsHash;
  };
in
stdenv.mkDerivation {
  inherit buildInputs nativeBuildInputs;
  inherit (source) pname src version;
  __structuredAttrs = true;
  buildPhase = ''
    runHook preBuild
    bazel build \
      --action_env=HOME \
      --lockfile_mode=error \
      --vendor_dir=vendor_dir \
      ${lib.escapeShellArgs bazelArgs}
    runHook postBuild
  '';
  desktopItems = lib.optionals withIbus [
    (makeDesktopItem {
      desktopName = "Mozkey Setup";
      exec = "@out@/lib/mozc/mozc_tool --mode=config_dialog";
      name = "ibus-setup-mozkey-jp";
      noDisplay = true;
      startupNotify = true;
      type = "Application";
    })
  ];
  env = {
    USER = "nixbld";
    USE_BAZEL_VERSION = bazel.version;
  };
  installPhase = ''
    runHook preInstall
    install -Dm555 bazel-bin/server/mozc_server "$out/lib/mozc/mozc_server"
    install -Dm555 bazel-bin/gui/tool/mozc_tool "$out/lib/mozc/mozc_tool"
    install -Dm555 bazel-bin/unix/emacs/mozc_emacs_helper "$out/bin/mozc_emacs_helper"
    install -Dm444 unix/emacs/mozc.el "$out/share/emacs/site-lisp/emacs-mozc/mozc.el"
  ''
  + lib.optionalString withIbus ''
    install -Dm555 bazel-bin/renderer/qt/mozc_renderer "$out/lib/mozc/mozc_renderer"
    install -Dm555 bazel-bin/unix/ibus/ibus_mozc "$out/lib/ibus-mozc/ibus-engine-mozc"
    install -Dm555 bazel-bin/unix/ibus/mozc.xml "$out/share/ibus/component/mozc.xml"
    unzip bazel-bin/unix/icons.zip -d "$out/share/ibus-mozc/"
    install -Dm444 data/images/product_icon_32bpp-128.png "$out/share/ibus-mozc/product_icon.png"
    install -Dm444 data/images/icon.svg "$out/share/ibus-mozc/product_icon.svg"
  ''
  + ''
    install -Dm444 ../LICENSE "$out/share/licenses/$pname/LICENSE"
    install -Dm444 ../dist/dictionary/koyasi-syntax-guard-debug.tsv "$dic/dist/dictionary/koyasi-syntax-guard-debug.tsv"
    install -Dm444 data/dictionary_koyasi/generated/profiled/koyasi-syntax-guard.txt "$dic/src/data/dictionary_koyasi/generated/profiled/koyasi-syntax-guard.txt"
    install -Dm444 data/dictionary_koyasi/generated/profiled/mozcdic-ut-daily.txt "$dic/src/data/dictionary_koyasi/generated/profiled/mozcdic-ut-daily.txt"
    install -Dm444 data/dictionary_koyasi/generated/profiled/mozcdic-ut-personal-names-daily.txt "$dic/src/data/dictionary_koyasi/generated/profiled/mozcdic-ut-personal-names-daily.txt"
    runHook postInstall
  '';
  meta = {
    changelog = "https://github.com/koyasi777/mozkey/releases/tag/v${source.version}";
    description = "A unofficial fork of Mozc";
    homepage = "https://github.com/koyasi777/mozkey";
    isIbusEngine = withIbus;
    license = lib.licenses.free;
    mainProgram = "mozc_emacs_helper";
    platforms = lib.platforms.linux;
  };
  outputs = [
    "out"
    "dic"
  ];
  passthru = {
    inherit
      bazel
      bazelCommonArgs
      mkVendorDeps
      setupBazelVendor
      vendorDeps
      ;
  };
  patches = [
    ./1-merge-ut-positive-daily-from-nixpkgs.patch
    ./3-qt-new-class-name.patch
  ];
  postFixup = lib.optionalString withIbus ''
    substituteInPlace "$out/share/applications/ibus-setup-mozkey-jp.desktop" \
      --subst-var out
  '';
  postPatch = ''
    cd src
    ${setupBazelVendor vendorDeps}
    substituteInPlace config.bzl \
      --replace-fail "/usr/bin/xdg-open" "${xdg-utils}/bin/xdg-open" \
      --replace-fail "/usr" "$out"
  ''
  + lib.optionalString (dictionaries' != [ ]) ''
    mkdir -p data/dictionary_koyasi/generated/{nico_pixiv,personal_names}
    cp -f ${ut-dictionary}/mozcdic-ut.txt data/dictionary_koyasi/generated/mozcdic-ut-${dictionaryProfile}.txt
    cp -f ${ut-dictionary-sample}/mozcdic-ut.txt data/dictionary_koyasi/generated/mozcdic-ut-safe.txt
    cp -f ${dic-nico-intersection-pixiv} data/dictionary_koyasi/generated/nico_pixiv/dic-nico-intersection-pixiv-google.txt
    cp -f ${ut-dictionary-personal-names}/mozcdic-ut.txt data/dictionary_koyasi/generated/personal_names/mozcdic-ut-personal-names.txt
  '';
  preBuild = ''
    pwsh ../tools/dictionary/prepare_daily_dictionary.ps1 -SkipDownload
  '';
  sourceRoot = "mozkey-${source.version}";
  strictDeps = true;
}
