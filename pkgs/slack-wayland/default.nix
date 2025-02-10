{
  lib,
  slack,
  stdenv,
  xdg-utils,
}:
slack.overrideAttrs (
  _: prev: {
    installPhase =
      ''
        runHook preInstall

        # The deb file contains a setuid binary, so 'dpkg -x' doesn't work here
        dpkg --fsys-tarfile $src | tar --extract
        rm -rf usr/share/lintian

        mkdir -p $out
        mv usr/* $out

        # Otherwise it looks "suspicious"
        chmod -R g-w $out

        for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
          patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
          patchelf --set-rpath ${prev.rpath}:$out/lib/slack $file || true
        done

        # Replace the broken bin/slack symlink with a startup wrapper.
        # Make xdg-open overrideable at runtime.
        rm $out/bin/slack
        makeWrapper $out/lib/slack/slack $out/bin/slack \
          --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
          --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer}}" \
          --add-flags "--enable-wayland-ime" \
          --add-flags "--disable-gpu-compositing"

        # Fix the desktop link
        substituteInPlace $out/share/applications/slack.desktop \
          --replace /usr/bin/ $out/bin/ \
          --replace /usr/share/pixmaps/slack.png slack \
          --replace bin/slack "bin/slack -s"
      ''
      + lib.optionalString stdenv.hostPlatform.isLinux ''
        # Prevent Un-blacklist pipewire integration to enable screen sharing on wayland.
        # https://github.com/flathub/com.slack.Slack/issues/101#issuecomment-1807073763
        sed -i -e 's/,"WebRTCPipeWireCapturer"/,"LebRTCPipeWireCapturer"/' $out/lib/slack/resources/app.asar
      ''
      + ''
        runHook postInstall
      '';
  }
)
