{ discord-canary }:
discord-canary.overrideAttrs (
  _: _: {
    preInstall = ''
      gappsWrapperArgs+=(
        --add-flags "--enable-wayland-ime"
        --add-flags "--disable-gpu-compositing"
      )
    '';
  }
)
