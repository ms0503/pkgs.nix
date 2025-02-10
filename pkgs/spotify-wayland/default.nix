{ spotify }:
spotify.overrideAttrs (
  _: _: {
    preFixup = ''
      gappsWrapperArgs+=(
        --add-flags "--enable-wayland-ime"
        --add-flags "--disable-gpu-compositing"
      )
    '';
  }
)
