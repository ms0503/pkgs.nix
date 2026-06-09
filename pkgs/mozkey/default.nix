# Packaging this package is supported by OpenAI Codex. Thanks!
{
  bazel_7,
  buildBazelPackage,
  dic-nico-intersection-pixiv,
  dictionaries ? [ ],
  dictionaryProfile ? "daily",
  fetchFromGitHub,
  gnused,
  ibus,
  jp-zip-codes,
  lib,
  merge-ut-dictionaries,
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
  protobuf_30,
  python3Packages,
  qt6,
  source,
  unzip,
  withIbus ? false,
  xdg-utils,
}:
let
  inherit (python3Packages) python;
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
  registry = fetchFromGitHub {
    hash = "sha256-OcMLg0KiAQOJZLH8r+QkeQ9bxcEc4L0dCgyUv5PkLQk=";
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "0f256a72067e42d62bb568cc2619f98deed139e2";
  };
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
in
buildBazelPackage rec {
  inherit (source) pname src version;
  bazel = bazel_7;
  bazelFlags = [
    "--compilation_mode"
    "opt"
    "--config"
    "oss_linux"
    "--python_path"
    "${python}/bin/python3"
    "--registry"
    "file://${registry}"
  ];
  bazelTargets = [
    "gui/tool:mozc_tool"
    "renderer/qt:mozc_renderer"
    "server:mozc_server"
    "unix/emacs:mozc.el"
    "unix/emacs:mozc_emacs_helper"
    "unix/icons"
  ]
  ++ lib.optionals withIbus [
    "unix/ibus:gen_mozc_xml"
    "unix/ibus:ibus_mozc"
  ];
  buildAttrs.installPhase = ''
    runHook preInstall
    install -Dm555 "bazel-bin/server/mozc_server" "$out/lib/mozc/mozc_server"
    install -Dm555 "bazel-bin/renderer/qt/mozc_renderer" "$out/lib/mozc/mozc_renderer"
    install -Dm555 "bazel-bin/gui/tool/mozc_tool" "$out/lib/mozc/mozc_tool"
    install -Dm555 "bazel-bin/unix/emacs/mozc_emacs_helper" "$out/bin/mozc_emacs_helper"
    install -Dm444 "unix/emacs/mozc.el" "$out/share/emacs/site-lisp/emacs-mozc/mozc.el"
    install -d "$out/share/icons/mozc/"
    unzip bazel-bin/unix/icons.zip -d "$out/share/icons/mozc/"
  ''
  + (lib.optionalString withIbus ''
    install -Dm555 "bazel-bin/unix/ibus/ibus_mozc" "$out/lib/ibus-mozc/ibus-engine-mozc"
    install -Dm555 "bazel-bin/unix/ibus/mozc.xml" "$out/share/ibus/component/mozc.xml"
    install -d "$out/share/ibus-mozc/"
    for icon in $out/share/icons/mozc/*.png
    do
      cp $icon $out/share/ibus-mozc/
    done
    mv $out/share/ibus-mozc/{mozc,product_icon}.png
  '')
  + ''
    # create a desktop file for gnome-control-center
    # copied from ubuntu
    mkdir -p $out/share/applications
    cp ${./ibus-setup-mozkey-jp.desktop} $out/share/applications/ibus-setup-mozkey-jp.desktop
    substituteInPlace $out/share/applications/ibus-setup-mozkey-jp.desktop \
      --replace-fail "@mozkey@" "$out"
    runHook postInstall
  '';
  buildInputs = [
    qt6.qtbase
  ]
  ++ lib.optional withIbus ibus;
  dontAddBazelOpts = true;
  fetchAttrs = {
    __structuredAttrs = true;
    hash = "sha256-78kLV3qQjWZTM69yAY16tbhtvSi3j2ZuBpklq05SEBM=";
    preInstall = ''
      # Remove zip code data. It will be replaced with jp-zip-codes from nixpkgs
      rm -rvf "$bazelOut"/external/zip_code_{jigyosyo,ken_all}
      # Remove references to buildInputs
      rm -rvf "$bazelOut"/external/{ibus,qt_linux}
      # Remove reference to the host platform
      rm -rvf "$bazelOut"/external/host_platform
    '';
    unsafeDiscardReferences.out = true;
  };
  meta = {
    description = "A unofficial fork of Mozc";
    homepage = "https://github.com/koyasi777/mozkey";
    isIbusEngine = withIbus;
    license = lib.licenses.free;
    mainProgram = "mozc_emacs_helper";
    platforms = lib.platforms.linux;
  };
  nativeBuildInputs = [
    gnused
    pkg-config
    powershell
    python
    qt6.wrapQtAppsHook
    unzip
  ];
  patches = [
    ./0-protobuf-from-nixpkgs.patch
    ./1-merge-ut-positive-daily-from-nixpkgs.patch
    ./2-bazel-visibility-public-only.patch
  ];
  postPatch = ''
    mkdir -p src/third_party
    cp -r ${protobuf_30.src} src/third_party/protobuf
    substituteInPlace src/config.bzl \
      --replace-fail "/usr/bin/xdg-open" "${xdg-utils}/bin/xdg-open" \
      --replace-fail "/usr" "$out"
    substituteInPlace src/MODULE.bazel \
      --replace-fail "https://github.com/hiroyuki-komatsu/japanpost_zipcode/raw/621d059fbcbfae17bfca15b439692bae934268c3/ken_all.zip" "file://${jp-zip-codes}/ken_all.zip" \
      --replace-fail "https://github.com/hiroyuki-komatsu/japanpost_zipcode/raw/621d059fbcbfae17bfca15b439692bae934268c3/jigyosyo.zip" "file://${jp-zip-codes}/jigyosyo.zip" \
      --replace-fail "3adc97d8e19e1168a6cdcb2fce759d0e9e613a9a3b630cc180aecfd56ae81eaf" "ba4c5f20741eaa34651cbdea1e2832806cd12344c5ea15f5c0e8e2583149c836" \
      --replace-fail "14be1030f607c5f819f2f45a485e89511907bdd1d62e7fb1931b6e48a3431c3a" "5233fc9f7d2664eeb2cb35c82e78261e9450243ef818cfd27f823c4507f0714c"
  '';
  preBuild = ''
    pwsh ../tools/dictionary/prepare_daily_dictionary.ps1 -SkipDownload
  '';
  preConfigure = ''
    if [ -e "$bazelOut"/external/rules_python~/python/private/py_runtime_info.bzl ]; then
      substituteInPlace "$bazelOut"/external/rules_python~/python/private/py_runtime_info.bzl \
        --replace-fail 'DEFAULT_STUB_SHEBANG = "#!/usr/bin/env python3"' 'DEFAULT_STUB_SHEBANG = "#!${python}/bin/python3"'
      substituteInPlace "$bazelOut"/external/rules_python~/python/private/py_executable.bzl \
        --replace-fail 'ctx.actions.write(prelude, "#!/usr/bin/env python3\n")' 'ctx.actions.write(prelude, "#!${python}/bin/python3\n")'
      ${python}/bin/python3 -c "import os, pathlib; p = pathlib.Path(os.environ['bazelOut']) / 'external/rules_python~/python/private/py_executable.bzl'; s = p.read_text(); old = 'def _get_interpreter_path(ctx, *, runtime, flag_interpreter_path):\n    if runtime:'; new = 'def _get_interpreter_path(ctx, *, runtime, flag_interpreter_path):\n    if flag_interpreter_path:\n        interpreter_path = flag_interpreter_path\n    elif runtime:'; assert old in s; p.write_text(s.replace(old, new, 1))"
      grep -q '    elif runtime:' "$bazelOut"/external/rules_python~/python/private/py_executable.bzl
      ${python}/bin/python3 -c "import os, pathlib; p = pathlib.Path(os.environ['bazelOut']) / 'external/rules_python~/python/private/py_executable.bzl'; s = p.read_text(); old = 'def _maybe_get_runtime_from_ctx(ctx):\n    \"\"\"Finds'; new = 'def _maybe_get_runtime_from_ctx(ctx):\n    return None\n    \"\"\"Finds'; assert old in s; p.write_text(s.replace(old, new, 1))"
      grep -q '    return None' "$bazelOut"/external/rules_python~/python/private/py_executable.bzl
    fi
    cd src
  ''
  + lib.optionalString (dictionaries' != [ ]) ''
    mkdir -p data/dictionary_koyasi/generated/{nico_pixiv,personal_names}
    cp -f ${ut-dictionary}/mozcdic-ut.txt data/dictionary_koyasi/generated/mozcdic-ut-${dictionaryProfile}.txt
    cp -f ${ut-dictionary-sample}/mozcdic-ut.txt data/dictionary_koyasi/generated/mozcdic-ut-safe.txt
    cp -f ${dic-nico-intersection-pixiv} data/dictionary_koyasi/generated/nico_pixiv/dic-nico-intersection-pixiv-google.txt
    cp -f ${ut-dictionary-personal-names}/mozcdic-ut.txt data/dictionary_koyasi/generated/personal_names/mozcdic-ut-personal-names.txt
  '';
  removeRulesCC = false;
  sourceRoot = "mozkey-${version}";
}
