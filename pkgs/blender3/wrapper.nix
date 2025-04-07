{
  blender,
  extraModules ? [ ],
  makeWrapper,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  inherit (blender) meta version;
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/"{bin,share/applications}
    sed 's/Exec=blender3/Exec=${finalAttrs.finalPackage.pname}/g' "$src/share/applications/blender3.desktop" >"$out/share/applications/${finalAttrs.finalPackage.pname}.desktop"
    cp -r "$src/share/"{blender,doc,icons} "$out/share"
    buildPythonPath "$pythonPath"
    makeWrapper "${blender}/bin/blender3" "$out/bin/${finalAttrs.finalPackage.pname}" \
      --prefix PATH : "$program_PATH" \
      --prefix PYTHONPATH : "$program_PYTHONPATH"
    runHook postInstall
  '';
  nativeBuildInputs = [
    blender.pythonPackages.wrapPython
    makeWrapper
  ];
  pname = blender.pname + "-wrapped";
  pythonPath = extraModules;
  src = blender;
})
