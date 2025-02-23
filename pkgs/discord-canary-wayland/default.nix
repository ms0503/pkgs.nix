{ discord-canary }:
discord-canary.overrideAttrs (
  _: prev: {
    pname = prev.pname + "-wayland";
    preInstall = ''
      gappsWrapperArgs+=(
        --add-flags "--enable-wayland-ime"
        --add-flags "--disable-gpu-compositing"
      )
    '';
  }
)
