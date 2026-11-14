{
  cargoHash,
  icu,
  lib,
  makeWrapper,
  mold,
  pkg-config,
  rustPlatform,
  source,
  zstd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  inherit cargoHash;
  inherit (source) pname src version;
  EDIT_CFG_ICU_EXPORT_SUFFIX = "_${lib.versions.major icu.version}";
  LD_LIBRARY_PATH =
    [
      icu
    ]
    |> lib.makeLibraryPath;
  RUSTFLAGS = "-Clink-arg=-fuse-ld=mold";
  buildInputs = [
    zstd
  ];
  meta = {
    description = "A simple editor for simple needs";
    downloadPage = "https://github.com/microsoft/edit/releases";
    homepage = "https://github.com/microsoft/edit";
    license = lib.licenses.mit;
    mainProgram = "edit";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
  nativeBuildInputs = [
    makeWrapper
    mold
    pkg-config
  ];
  postInstall = ''
    wrapProgram "$out/bin/edit" \
      --prefix LD_LIBRARY_PATH : "${finalAttrs.LD_LIBRARY_PATH}"
  '';
})
