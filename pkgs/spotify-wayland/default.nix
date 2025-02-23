{ spotify }:
spotify.overrideAttrs (
  _: prev: {
    pname = prev.pname + "-wayland";
    preFixup = ''
      gappsWrapperArgs+=(
        --add-flags "--enable-wayland-ime"
        --add-flags "--disable-gpu-compositing"
      )
    '';
  }
)
