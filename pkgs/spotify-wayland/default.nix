{ spotify }:
spotify.overrideAttrs (
  _: prev: {
    meta = {
      inherit (prev.meta) mainProgram;
      description = prev.meta.description + ", including Wayland support";
    };
    pname = prev.pname + "-wayland";
    preFixup = ''
      gappsWrapperArgs+=(
        --add-flags "--enable-wayland-ime"
        --add-flags "--disable-gpu-compositing"
        --add-flags "--enable-features=UseOzonePlatform"
        --add-flags "--ozone-platform=wayland"
      )
    '';
  }
)
