{ microsoft-edge-dev }:
(microsoft-edge-dev.override (_: {
  commandLineArgs = "--disable-gpu-compositing";
})).overrideAttrs
  (
    _: prev: {
      meta = {
        inherit (prev.meta) mainProgram;
        description = prev.meta.description + ", including Wayland support";
      };
      pname = prev.pname + "-wayland";
    }
  )
