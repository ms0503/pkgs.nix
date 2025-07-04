{
  addDriverRunpath,
  adwaita-icon-theme,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  bzip2,
  cairo,
  commandLineArgs ? "",
  coreutils,
  cups,
  curl,
  dbus,
  expat,
  fetchurl,
  flac,
  fontconfig,
  freetype,
  gcc-unwrapped,
  gdk-pixbuf,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  gtk4,
  harfbuzz,
  icu,
  lib,
  libX11,
  libXScrnSaver,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libcap,
  libdrm,
  liberation_ttf,
  libexif,
  libgbm,
  libglvnd,
  libkrb5,
  libopus,
  libpng,
  libpulseaudio,
  libuuid,
  libva,
  libvaSupport ? true,
  libxcb,
  libxkbcommon,
  libxshmfence,
  makeWrapper,
  mesa,
  nspr,
  nss,
  pango,
  patchelf,
  pciutils,
  pipewire,
  pulseSupport ? true,
  snappy,
  speechd-minimal,
  stdenv,
  systemd,
  util-linux,
  vulkan-loader,
  wayland,
  wget,
  xdg-utils,
}:
let
  deps =
    [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      bzip2
      cairo
      coreutils
      cups
      curl
      dbus
      expat
      flac
      fontconfig
      freetype
      gcc-unwrapped.lib
      gdk-pixbuf
      glib
      gtk3
      gtk4
      harfbuzz
      icu
      libX11
      libXScrnSaver
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libXrandr
      libXrender
      libXtst
      libcap
      libdrm
      liberation_ttf
      libexif
      libgbm
      libglvnd
      libkrb5
      libpng
      libuuid
      libxcb
      libxkbcommon
      libxshmfence
      mesa
      nspr
      nss
      opusWithCustomModes
      pango
      pciutils
      pipewire
      snappy
      speechd-minimal
      systemd
      util-linux
      vulkan-loader
      wayland
      wget
    ]
    ++ lib.optional pulseSupport libpulseaudio
    ++ lib.optional libvaSupport libva;
  opusWithCustomModes = libopus.override { withCustomModes = true; };
  src = fetchurl {
    hash = "sha256-ebc8mGFcp0YmHlu3TvMz6cSwMGYuFKXwJJI0NFxWXcQ=";
    url = "https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-dev/microsoft-edge-dev_${version}-1_amd64.deb";
  };
  version = "139.0.3394.0";
in
stdenv.mkDerivation (finalAttrs: {
  inherit src version;
  binpath = lib.makeBinPath deps;
  buildInputs = [
    adwaita-icon-theme
    glib
    gsettings-desktop-schemas
    gtk3
    gtk4
  ];
  installPhase = ''
    runHook preInstall

    appname=msedge-dev

    exe=$out/bin/microsoft-edge-dev

    mkdir -p "$out/bin" "$out/share"
    cp -v -a opt/* "$out/share"
    cp -v -a usr/share/* "$out/share"

    # replace bundled vulkan-loader
    rm -v "$out/share/microsoft/$appname/libvulkan.so.1"
    ln -v -s -t "$out/share/microsoft/$appname" "${lib.getLib vulkan-loader}/lib/libvulkan.so.1"

    substituteInPlace "$out/share/microsoft/$appname/microsoft-edge-dev" \
      --replace-fail 'CHROME_WRAPPER' 'WRAPPER'
    substituteInPlace "$out/share/applications/microsoft-edge-dev.desktop" \
      --replace-fail "/usr/bin/microsoft-edge-dev" "$exe"
    substituteInPlace "$out/share/gnome-control-center/default-apps/microsoft-edge-dev.xml" \
      --replace-fail "/opt/microsoft/$appname/microsoft-edge-dev" "$exe"
    substituteInPlace "$out/share/menu/microsoft-edge-dev.menu" \
      --replace-fail /opt "$out/share" \
      --replace-fail "$out/share/microsoft/$appname/microsoft-edge-dev" "$exe"

    for icon_file in "$out/share/microsoft/$appname/product_logo_"[0-9][0-9]"_$dist.png"; do
      num_and_suffix=''${icon_file##*logo_}
      icon_size=''${num_and_suffix%_*}
      logo_output_prefix=$out/share/icons/hicolor
      logo_output_path=$logo_output_prefix/''${icon_size}x''${icon_size}/apps
      mkdir -p "$logo_output_path"
      mv "$icon_file" "$logo_output_path/microsoft-edge-dev.png"
    done

    # "--simulate-outdated-no-au" disables auto updates and browser outdated popup
    makeWrapper "$out/share/microsoft/$appname/microsoft-edge-dev" "$exe" \
      --prefix LD_LIBRARY_PATH : "$rpath" \
      --prefix PATH            : "$binpath" \
      --suffix PATH            : "${lib.makeBinPath [ xdg-utils ]}" \
      --prefix XDG_DATA_DIRS   : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:${addDriverRunpath.driverLink}/share" \
      --set CHROME_WRAPPER "microsoft-edge-$dist" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --add-flags "--simulate-outdated-no-au='Tue, 31 Dec 2099 23:59:59 GMT'" \
      --add-flags "\''${WAYLAND_DISPLAY:+--enable-wayland-ime}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    # Make sure that libGL and libvulkan are found by ANGLE libGLESv2.so
    patchelf --set-rpath "$rpath" "$out/share/microsoft/$appname/lib"*GL*

    # Edge specific set liboneauth
    patchelf --set-rpath "$rpath" "$out/share/microsoft/$appname/liboneauth.so"

    for elf in "$out/share/microsoft/$appname/"{msedge,msedge-sandbox,msedge_crashpad_handler}; do
      patchelf --set-rpath "$rpath" "$elf"
      patchelf --set-interpreter "$(cat "$NIX_CC/nix-support/dynamic-linker")" "$elf"
    done

    runHook postInstall
  '';
  meta = {
    description = "Web browser from Microsoft, weekly build";
    homepage = "https://www.microsoft.com/en-us/edge";
    license = lib.licenses.unfree;
    mainProgram = "microsoft-edge-dev";
    platforms = [
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
    ];
  };
  nativeBuildInputs = [
    makeWrapper
    patchelf
  ];
  passthru.updateScript = ./update.sh;
  pname = "microsoft-edge-dev";
  rpath = lib.makeLibraryPath deps + ":" + lib.makeSearchPathOutput "lib" "lib64" deps;
  strictDeps = false;
  unpackPhase = ''
    runHook preUnpack
    ar x "$src"
    tar xf data.tar.xz
    runHook postUnpack
  '';
})
