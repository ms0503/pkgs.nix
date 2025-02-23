{ microsoft-edge-dev }:
(microsoft-edge-dev.override (_: {
  commandLineArgs = "--disable-gpu-compositing";
})).overrideAttrs
  (
    _: prev: {
      pname = prev.pname + "-wayland";
    }
  )
