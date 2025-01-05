{
  lib,
  source,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit (source) pname src version;
  buildCommand = ''
    runHook preBuild

    # Make it impossible to add to an environment. You should use the appropriate NixOS option.
    # Also leave some breadcrumbs in the file.
    echo "${finalAttrs.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    mkdir $steamcompattool
    ln -s $src/* $steamcompattool
    rm $steamcompattool/{compatibilitytool.vdf,proton,version}
    cp $src/{compatibilitytool.vdf,proton,version} $steamcompattool

    sed -i -r 's|GE-Proton[0-9]*-[0-9]*-rtsp[0-9]*|GE-Proton-rtsp|' $steamcompattool/compatibilitytool.vdf
    sed -i -r 's|GE-Proton[0-9]*-[0-9]*-rtsp[0-9]*|GE-Proton-rtsp|' $steamcompattool/proton

    runHook postBuild
  '';
  meta = {
    description = ''
      Compatibility tool for Steam Play based on Wine and additional components.

      (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
    '';
    homepage = "https://github.com/SpookySkeletons/proton-ge-rtsp";
    license = lib.licenses.bsd3;
    platforms = [
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
    ];
  };
  outputs = [
    "out"
    "steamcompattool"
  ];
})
