{ discord-canary }:
discord-canary.overrideAttrs (
  _: prev: {
    meta = {
      inherit (prev.meta) mainProgram;
      description = prev.meta.description + ", including Wayland support";
    };
    pname = prev.pname + "-wayland";
    preInstall = ''
      gappsWrapperArgs+=(
        --add-flags "--enable-wayland-ime"
        --add-flags "--disable-gpu-compositing"
      )
    '';
  }
)
