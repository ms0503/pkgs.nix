{
  bazel_7,
  buildBazelPackage,
  dic-nico-intersection-pixiv,
  dictionaries ? [ ],
  dictionaryProfile ? "daily",
  fcitx5,
  fetchFromGitHub,
  gettext,
  gnused,
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
  mozkey,
  pkg-config,
  powershell,
  protobuf_30,
  python3Packages,
  source,
  unzip,
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
  fcitx5MozcSrc = fetchFromGitHub {
    owner = "fcitx";
    repo = "mozc";
    rev = "57e67f2a25e4c0861e0e422da0c7d4c232d89fcc";
    hash = "sha256-1EZjEbMl+LRipH5gEgFpaKP8uEKPfupHmiiTNJc/T1k=";
  };
  registry = fetchFromGitHub {
    hash = "sha256-OcMLg0KiAQOJZLH8r+QkeQ9bxcEc4L0dCgyUv5PkLQk=";
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "0f256a72067e42d62bb568cc2619f98deed139e2";
  };
  ut-dictionary = merge-ut-dictionaries.override {
    dictionaries = dictionaries';
  };
  ut-dictionary-sample = merge-ut-dictionaries.override {
    dictionaries = [
      mozcdic-ut-place-names
      mozcdic-ut-sudachidict
    ];
  };
in
buildBazelPackage rec {
  inherit (source) src version;
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
    "unix/fcitx5:fcitx5-mozc.so"
    "unix/icons"
  ];
  buildAttrs.installPhase = ''
    runHook preInstall

    install -Dm444 ../LICENSE "$out/share/licenses/fcitx5-mozkey/LICENSE"
    install -Dm444 data/installer/credits_en.html "$out/share/licenses/fcitx5-mozkey/Submodules"

    install -Dm555 bazel-bin/unix/fcitx5/fcitx5-mozc.so "$out/lib/fcitx5/fcitx5-mozc.so"
    install -Dm444 unix/fcitx5/mozc-addon.conf "$out/share/fcitx5/addon/mozc.conf"
    install -Dm444 unix/fcitx5/mozc.conf "$out/share/fcitx5/inputmethod/mozc.conf"

    for pofile in unix/fcitx5/po/*.po; do
      filename=$(basename "$pofile")
      lang=''${filename/.po/}
      mofile=''${pofile/.po/.mo}
      msgfmt "$pofile" -o "$mofile"
      install -Dm444 "$mofile" "$out/share/locale/$lang/LC_MESSAGES/fcitx5-mozc.mo"
    done

    msgfmt --xml -d unix/fcitx5/po/ --template unix/fcitx5/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml.in -o unix/fcitx5/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml
    install -Dm444 unix/fcitx5/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml "$out/share/metainfo/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml"

    cd bazel-bin/unix
    unzip -o icons.zip

    install -Dm444 mozc.png "$out/share/icons/hicolor/128x128/apps/org.fcitx.Fcitx5.fcitx_mozc.png"
    ln -s org.fcitx.Fcitx5.fcitx_mozc.png "$out/share/icons/hicolor/128x128/apps/fcitx_mozc.png"

    for svg in \
      alpha_full.svg \
      alpha_half.svg \
      direct.svg \
      hiragana.svg \
      katakana_full.svg \
      katakana_half.svg \
      outlined/dictionary.svg \
      outlined/properties.svg \
      outlined/tool.svg
    do
      name=$(basename -- "$svg")
      path="$out/share/icons/hicolor/scalable/apps"
      prefix=org.fcitx.Fcitx5.fcitx_mozc

      install -Dm444 "$svg" "$path/''${prefix}_$name"
      ln -s "''${prefix}_$name" "$path/fcitx_mozc_$name"
    done

    runHook postInstall
  '';
  buildInputs = [
    fcitx5
    mozkey
  ];
  dontAddBazelOpts = true;
  fetchAttrs = {
    __structuredAttrs = true;
    hash = "sha256-odK692yB9yHZKqfPoEC7q0wxLwDNkHgpj7z/gtKaII0=";
    preInstall = ''
      # Remove zip code data. It will be replaced with jp-zip-codes from nixpkgs
      rm -rvf "$bazelOut"/external/zip_code_{jigyosyo,ken_all}
      # Remove references to buildInputs
      rm -rvf "$bazelOut"/external/fcitx5
      # Remove reference to the host platform
      rm -rvf "$bazelOut"/external/host_platform
    '';
    unsafeDiscardReferences.out = true;
  };
  meta = {
    description = "Fcitx 5 module for Mozkey";
    homepage = "https://github.com/koyasi777/mozkey";
    license = lib.licenses.free;
    platforms = lib.platforms.linux;
  };
  nativeBuildInputs = [
    gettext
    gnused
    pkg-config
    powershell
    python
    unzip
  ];
  patches = [
    ../mozkey/0-protobuf-from-nixpkgs.patch
    ../mozkey/1-merge-ut-positive-daily-from-nixpkgs.patch
    ../mozkey/2-bazel-visibility-public-only.patch
  ];
  pname = "fcitx5-mozkey";
  postPatch = ''
    mkdir -p src/third_party
    cp -r ${protobuf_30.src} src/third_party/protobuf
    cp -r ${fcitx5MozcSrc}/src/unix/fcitx5 src/unix/fcitx5
    chmod -R u+w src/unix/fcitx5
    patch -p1 <${./handle-mozkey-live-conversion-callback.patch}

    substituteInPlace src/unix/fcitx5/mozc_response_parser.cc \
      --replace-fail "protocol/candidates.pb.h" "protocol/candidate_window.pb.h" \
      --replace-fail "response.has_candidates()" "response.has_candidate_window()" \
      --replace-fail "response.candidates()" "response.candidate_window()"
    substituteInPlace src/unix/fcitx5/mozc_response_parser.h \
      --replace-fail "class Candidates;" "class CandidateWindow; using Candidates = CandidateWindow;"
    substituteInPlace src/unix/fcitx5/mozc_state.cc \
      --replace-fail "SessionCommand::SWITCH_INPUT_MODE" "SessionCommand::SWITCH_COMPOSITION_MODE"
    sed -i '/"\/\/protocol:commands_cc_proto",/i\        "//protocol:candidate_window_cc_proto",' src/unix/fcitx5/BUILD

    substituteInPlace src/config.bzl \
      --replace-fail "/usr/lib/mozc" "${mozkey}/lib/mozc"
    substituteInPlace src/MODULE.bazel \
      --replace-fail "https://github.com/hiroyuki-komatsu/japanpost_zipcode/raw/621d059fbcbfae17bfca15b439692bae934268c3/ken_all.zip" "file://${jp-zip-codes}/ken_all.zip" \
      --replace-fail "https://github.com/hiroyuki-komatsu/japanpost_zipcode/raw/621d059fbcbfae17bfca15b439692bae934268c3/jigyosyo.zip" "file://${jp-zip-codes}/jigyosyo.zip" \
      --replace-fail "3adc97d8e19e1168a6cdcb2fce759d0e9e613a9a3b630cc180aecfd56ae81eaf" "ba4c5f20741eaa34651cbdea1e2832806cd12344c5ea15f5c0e8e2583149c836" \
      --replace-fail "14be1030f607c5f819f2f45a485e89511907bdd1d62e7fb1931b6e48a3431c3a" "5233fc9f7d2664eeb2cb35c82e78261e9450243ef818cfd27f823c4507f0714c"

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
      >> src/MODULE.bazel
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
    mkdir -p data/dictionary_koyasi/generated/nico_pixiv
    cp -f ${ut-dictionary}/mozcdic-ut.txt data/dictionary_koyasi/generated/mozcdic-ut-${dictionaryProfile}.txt
    cp -f ${ut-dictionary-sample}/mozcdic-ut.txt data/dictionary_koyasi/generated/mozcdic-ut-safe.txt
    cp -f ${dic-nico-intersection-pixiv} data/dictionary_koyasi/generated/nico_pixiv/dic-nico-intersection-pixiv-google.txt
  '';
  removeRulesCC = false;
  sourceRoot = "mozkey-${version}";
}
