{
  cpio,
  fetchurl,
  gcc,
  gdk-pixbuf,
  glib,
  gtk3,
  lib,
  libglvnd,
  libxml2,
  makeDesktopItem,
  noto-fonts-cjk-sans-non-variable,
  p7zip,
  stdenvNoCC,
  udev,
  xorg,
}:
let
  desktop = makeDesktopItem {
    desktopName = "Unity 2022.3.22f1";
    exec = "${unity}/opt/Unity/2022.3.22f1/Editor/Unity";
    icon = "unity-vrc-2022";
    name = "unity-vrc-2022";
  };
  sources = {
    android.src = fetchurl {
      url = "https://netstorage.unity3d.com/unity/887be4894c44/MacEditorTargetInstaller/UnitySetup-Android-Support-for-Editor-2022.3.22f1.pkg";
      sha256 = "sha256-Vqk8HgnFsUzjLvjIhIdJTLFHpyE6UDhwR7hN7/Jjpak=";
    };
    editor = {
      pname = "unity-vrc-2022-editor";
      version = "2022.3.22f1";
      src = fetchurl {
        url = "https://netstorage.unity3d.com/unity/887be4894c44/LinuxEditorInstaller/Unity.tar.xz";
        sha256 = "sha256-eE//d2kFHA9p7bA52NCUMeeuQASmSh20QDcJ3biKpQY=";
      };
    };
    ios.src = fetchurl {
      url = "https://netstorage.unity3d.com/unity/887be4894c44/LinuxEditorTargetInstaller/UnitySetup-iOS-Support-for-Editor-2022.3.22f1.tar.xz";
      sha256 = "sha256-gKMWWq6kEpvZ3xWrWhkYHpohLLVhcCh324I5TKwkVT4=";
    };
    ja.src = fetchurl {
      url = "https://new-translate.unity3d.jp/v1/live/54/2022.3/ja";
      sha256 = "sha256-ASOiiuIMSLQX5xFfM+VGHz+G9c6+DAC2DDzikRl69YI=";
    };
    ko.src = fetchurl {
      url = "https://new-translate.unity3d.jp/v1/live/54/2022.3/ko";
      sha256 = "sha256-eFn6vorKnpaulkL2emKtRVizxVvEUJf/wXQtQo/cagI=";
    };
    windows.src = fetchurl {
      url = "https://netstorage.unity3d.com/unity/887be4894c44/MacEditorTargetInstaller/UnitySetup-Windows-Mono-Support-for-Editor-2022.3.22f1.pkg";
      sha256 = "sha256-iBGBpsg3IwooTqQSC/y14qq5QLuQEOvftQ07iGXCBZ0=";
    };
    zh-hans.src = fetchurl {
      url = "https://new-translate.unity3d.jp/v1/live/54/2022.3/zh-hans";
      sha256 = "sha256-FKrlo5ShrNXbwSKzqeHk+rVdtUAq+kcEE/f9zvRn8cU=";
    };
    zh-hant.src = fetchurl {
      url = "https://new-translate.unity3d.jp/v1/live/54/2022.3/zh-hant";
      sha256 = "sha256-DzC5gE3xi/vhAm5dduqw+4EPFpAGfSiiFxY3nAv70Tw=";
    };
  };
  unity = stdenvNoCC.mkDerivation {
    inherit (sources.editor) version;
    installPhase = ''
      runHook preInstall
      install -Dm444 Editor/Data/Resources/UnityPlayerIcon.png "$out/share/icons/hicolor/64x64/apps/unity-vrc-2022.png"
      install -Dm444 Editor/Data/Resources/LargeUnityIcon.png "$out/share/icons/hicolor/256x256/apps/unity-vrc-2022.png"
      install -dm755 "$out/opt/Unity/2022.3.22f1"
      cp -r Editor "$out/opt/Unity/2022.3.22f1"
      install -Dm444 -t "$out/opt/Unity/2022.3.22f1/Editor/Data/Resources/Fonts" ${noto-fonts-cjk-sans-non-variable}/share/fonts/*/*/*
      install -Dm444 -t "$out/opt/Unity/2022.3.22f1/Editor/Data/Localization" {ja,ko,zh-hans,zh-hant}.po
      runHook postInstall
    '';
    meta = {
      description = "Unity for VRChat (2022.3.22f1)";
      downloadPage = "https://unity.com/releases/editor/whats-new/2022.3.22";
      homepage = "https://unity.com";
      license = lib.licenses.unfree;
      mainProgram = "../opt/Unity/2022.3.22f1/Editor/Unity";
      sourceProvenance = with lib.sourceTypes; [
        binaryNativeCode
      ];
    };
    nativeBuildInputs = [
      cpio
      p7zip
    ];
    pname = "unity-vrc-2022-editor";
    postFixup = ''
      patchelf --add-rpath "$rpath" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/7za" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/GeometryToolbox.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/JobProcess" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/UnityFileSystemApi.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/UnityShaderCompiler" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/UnityYAMLMerge" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/Unwrap.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/UnwrapCL" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/WebExtract" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/astcenc-avx2.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/astcenc-sse2.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/astcenc-sse42.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/binary2text" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/libCST.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/libCausticGLUT.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/libOpenImageDenoise.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/libOpenImageDenoise.so.1" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/libOpenImageDenoise.so.1.4.2" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/libRL.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/libUnityDenoisingPlugin.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/libdxcompiler.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/libembree.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/libembree.so.2" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/libfreeimage.so.3" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/libtbb.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/libtbb.so.2" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/libtbb.so.12" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/libtbb.so.12.4" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/libtbbmalloc.so.2" \
        "$out/opt/Unity/2022.3.22f1/Editor/Data/Tools/lzma-linux64" \
        "$out/opt/Unity/2022.3.22f1/Editor/Unity" \
        "$out/opt/Unity/2022.3.22f1/Editor/etccompress.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/libRL.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/libRadeonRays.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/libRadeonRays.so.2.0" \
        "$out/opt/Unity/2022.3.22f1/Editor/libcompress_bc7e.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/libembree.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/libfbxsdk.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/libfreeimage-3.18.0.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/libispc_texcomp.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/libre2.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/libre2.so.0" \
        "$out/opt/Unity/2022.3.22f1/Editor/libtbb.so.2" \
        "$out/opt/Unity/2022.3.22f1/Editor/libtbbmalloc.so.2" \
        "$out/opt/Unity/2022.3.22f1/Editor/libumbraoptimizer64.so" \
        "$out/opt/Unity/2022.3.22f1/Editor/s3tcompress.so"
    '';
    rpath = lib.makeLibraryPath (
      with xorg;
      [
        gcc.cc.lib
        gdk-pixbuf
        glib
        gtk3
        libX11
        libXcursor
        libXrandr
        libglvnd
        libxml2
        udev
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
