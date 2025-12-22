{
  addDriverRunpath,
  cacert,
  commandLineArgs ? "",
  fetchurl,
  lib,
  makeWrapper,
  microsoft-edge,
  patchelf,
  qt6,
  vulkan-loader,
  xdg-utils,
}:
let
  src = fetchurl {
    hash = "sha256-Zl1gAKaUnx8JJkTGE55UVJtKrsPKuB4+BlZOy3hyObQ=";
    url = "https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-dev/microsoft-edge-dev_${version}-1_amd64.deb";
  };
  version = "145.0.3734.1";
in
microsoft-edge.overrideAttrs (
  final: prev: {
    inherit src version;
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
      substituteInPlace "$out/share/applications/com.microsoft.Edge.dev.desktop" \
        --replace-fail "/usr/bin/microsoft-edge-dev" "$exe"
      substituteInPlace "$out/share/gnome-control-center/default-apps/microsoft-edge-dev.xml" \
        --replace-fail "/opt/microsoft/$appname/microsoft-edge-dev" "$exe"

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
        --prefix QT_PLUGIN_PATH : "${qt6.qtbase}/lib/qt-6/plugins" \
        --prefix QT_PLUGIN_PATH : "${qt6.qtwayland}/lib/qt-6/plugins" \
        --prefix NIXPKGS_QT6_QML_IMPORT_PATH : "${qt6.qtwayland}/lib/qt-6/qml" \
        --prefix LD_LIBRARY_PATH : "$rpath" \
        --prefix PATH            : "$binpath" \
        --suffix PATH            : "${lib.makeBinPath [ xdg-utils ]}" \
        --prefix XDG_DATA_DIRS   : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:${addDriverRunpath.driverLink}/share" \
        --set SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt" \
        --set CHROME_WRAPPER "microsoft-edge-$dist" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
        --add-flags "--simulate-outdated-no-au='Tue, 31 Dec 2099 23:59:59 GMT'" \
        --add-flags ${lib.escapeShellArg commandLineArgs}

      # Make sure that libGL and libvulkan are found by ANGLE libGLESv2.so
      patchelf --set-rpath "$rpath" "$out/share/microsoft/$appname/lib"*GL*

      # # Edge specific set liboneauth
      # patchelf --set-rpath "$rpath" "$out/share/microsoft/$appname/liboneauth.so"

      for elf in "$out/share/microsoft/$appname/"{msedge,msedge-sandbox,msedge_crashpad_handler}; do
        patchelf --set-rpath "$rpath" "$elf"
        patchelf --set-interpreter "$(cat "$NIX_CC/nix-support/dynamic-linker")" "$elf"
      done

      runHook postInstall
    '';
    meta = prev.meta // {
      description = "Web browser from Microsoft, weekly build";
      mainProgram = "microsoft-edge-dev";
    };
    nativeBuildInputs = prev.nativeBuildInputs ++ [
      makeWrapper
      patchelf
    ];
    passthru.updateScript = ./update.sh;
    pname = "microsoft-edge-dev";
  }
)
