{
  alsa-lib,
  at-spi2-core,
  cairo,
  cpio,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gcc,
  gdk-pixbuf,
  glib,
  gnome2,
  gtk3,
  lib,
  libcap,
  libglvnd,
  makeDesktopItem,
  noto-fonts-cjk-sans-non-variable,
  nspr,
  nss,
  p7zip,
  pango,
  sources,
  stdenvNoCC,
  xorg,
}:
let
  desktop = makeDesktopItem {
    desktopName = "Unity 2019.4.31f1";
    exec = "${unity}/opt/Unity/2019.4.31f1/Editor/Unity";
    icon = "unity-vrc-2019";
    name = "unity-vrc-2019";
  };
  unity = stdenvNoCC.mkDerivation {
    inherit (sources.editor) version;
    installPhase = ''
      runHook preInstall
      install -Dm444 Editor/Data/Resources/UnityPlayerIcon.png "$out/share/icons/hicolor/64x64/apps/unity-vrc-2019.png"
      install -Dm444 Editor/Data/Resources/LargeUnityIcon.png "$out/share/icons/hicolor/256x256/apps/unity-vrc-2019.png"
      install -dm755 "$out/opt/Unity/2019.4.31f1"
      cp -r Editor "$out/opt/Unity/2019.4.31f1"
      install -Dm444 -t "$out/opt/Unity/2019.4.31f1/Editor/Data/Resources/Fonts" ${noto-fonts-cjk-sans-non-variable}/share/fonts/*/*/*
      install -Dm444 -t "$out/opt/Unity/2019.4.31f1/Editor/Data/Localization" {ja,ko,zh-hans,zh-hant}.po
      runHook postInstall
    '';
    meta = {
      downloadPage = "https://unity.com/releases/editor/whats-new/2019.4.31";
      homepage = "https://unity.com";
      license = lib.licenses.unfree;
      sourceProvenance = with lib.sourceTypes; [
        binaryNativeCode
      ];
    };
    nativeBuildInputs = [
      cpio
      p7zip
    ];
    pname = "unity-vrc-2019-app";
    postFixup = ''
      patchelf --add-rpath "$rpath" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/7za" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/AssetCacheServer" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/JobProcess" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/UnityShaderCompiler" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/UnityYAMLMerge" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/UnwrapCL" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/WebExtract" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/binary2text" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/etccompress" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/glslang.so" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/libCST.so" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/libCausticGLUT.so" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/libOpenCL.so" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/libOpenCL.so.1" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/libOpenCL.so.1.0.0" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/libOpenImageDenoise.so" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/libOpenImageDenoise.so.0" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/libOpenImageDenoise.so.1.1.0" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/libRL.so" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/libembree.so" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/libembree.so.2" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/libfreeimage.so.3" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/libtbb.so.2" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/libtbbmalloc.so.2" \
        "$out/opt/Unity/2019.4.31f1/Editor/Data/Tools/lzma-linux64" \
        "$out/opt/Unity/2019.4.31f1/Editor/Unity" \
        "$out/opt/Unity/2019.4.31f1/Editor/UnityHelper" \
        "$out/opt/Unity/2019.4.31f1/Editor/chrome-sandbox" \
        "$out/opt/Unity/2019.4.31f1/Editor/libOpenCL.so" \
        "$out/opt/Unity/2019.4.31f1/Editor/libOpenCL.so.1" \
        "$out/opt/Unity/2019.4.31f1/Editor/libOpenCL.so.1.0.0" \
        "$out/opt/Unity/2019.4.31f1/Editor/libOpenImageDenoise.so" \
        "$out/opt/Unity/2019.4.31f1/Editor/libRL.so" \
        "$out/opt/Unity/2019.4.31f1/Editor/libcef.so" \
        "$out/opt/Unity/2019.4.31f1/Editor/libembree.so" \
        "$out/opt/Unity/2019.4.31f1/Editor/libfbxsdk.so" \
        "$out/opt/Unity/2019.4.31f1/Editor/libffmpegsumo.so" \
        "$out/opt/Unity/2019.4.31f1/Editor/libfreeimage-3.18.0.so" \
        "$out/opt/Unity/2019.4.31f1/Editor/libispc_texcomp.so" \
        "$out/opt/Unity/2019.4.31f1/Editor/libpdf.so" \
        "$out/opt/Unity/2019.4.31f1/Editor/libtbb.so.2" \
        "$out/opt/Unity/2019.4.31f1/Editor/libtbbmalloc.so.2" \
        "$out/opt/Unity/2019.4.31f1/Editor/libumbraoptimizer64.so"
    '';
    rpath = lib.makeLibraryPath (
      with xorg;
      [
        alsa-lib
        at-spi2-core
        cairo
        cups.lib
        dbus.lib
        expat
        fontconfig.lib
        freetype
        gcc.cc.lib
        gdk-pixbuf
        glib
        gnome2.GConf
        gtk3
        libX11
        libXcomposite
        libXcursor
        libXdamage
        libXext
        libXfixes
        libXi
        libXrandr
        libXrender
        libXtst
        libcap.lib
        libglvnd
        nspr
        nss
        pango
      ]
    );
    sourceRoot = ".";
    srcs = [
      sources.editor.src
      sources.android.src
      sources.ios.src
      sources.windows.src
      sources.ja.src
      sources.ko.src
      sources.zh-hans.src
      sources.zh-hant.src
    ];
    unpackPhase = ''
      runHook preUnpack
      srcs=($srcs)
      base_dir=$PWD
      tar xf "''${srcs[0]}"
      tar xf "''${srcs[2]}"
      7z x -oandroid "''${srcs[1]}"
      7z x -owindows "''${srcs[3]}"
      mkdir Editor/Data/PlaybackEngines/{AndroidPlayer,WindowsStandaloneSupport}
      pushd Editor/Data/PlaybackEngines/AndroidPlayer
      cpio -i <"$base_dir/android/Payload~"
      popd
      pushd Editor/Data/PlaybackEngines/WindowsStandaloneSupport
      cpio -i <"$base_dir/windows/Payload~"
      popd
      cp "''${srcs[4]}" ja.po
      cp "''${srcs[5]}" ko.po
      cp "''${srcs[6]}" zh-hans.po
      cp "''${srcs[7]}" zh-hant.po
      runHook postUnpack
    '';
  };
in
stdenvNoCC.mkDerivation {
  inherit (sources.editor) pname version;
  installPhase = ''
    runHook preInstall
    install -dm755 "$out/share"
    ln -s "${desktop}/share/applications" "$out/share/applications"
    ln -s "${unity}/opt" "$out/opt"
    ln -s "${unity}/share/icons" "$out/share/icons"
    runHook postInstall
  '';
  src = ./.;
}
