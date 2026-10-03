# This package is packaged by OpenAI Codex. Thanks!
{
  haskell,
  lib,
  source,
  stdenvNoCC,
}:
let
  haskellPackages = haskell.packages.ghc948.override {
    overrides = final: prev: {
      text-icu-translit =
        haskell.lib.overrideCabal
          (haskell.lib.dontCheck (
            haskell.lib.addBuildDepend (haskell.lib.unmarkBroken prev.text-icu-translit) final.bytestring
          ))
          (old: {
            postPatch = (old.postPatch or "") + ''
              substituteInPlace text-icu-translit.cabal \
                --replace-fail "text >= 1.0" "text >=1.0, bytestring"
              substituteInPlace Data/Text/ICU/Translit/Internal.hs \
                --replace-fail $'import Foreign\nimport Data.Text\nimport Data.Text.Foreign\nimport Data.Text.ICU.Translit.ICUHelper' \
                  $'import Foreign\nimport qualified Data.ByteString as BS\nimport qualified Data.ByteString.Unsafe as BSU\nimport Data.Text (Text)\nimport qualified Data.Text.Encoding as TE\nimport Data.Text.ICU.Translit.ICUHelper' \
                --replace-fail $'transliterator :: Text -> IO Transliterator\ntransliterator spec =\n    useAsPtr spec' \
                  $'withUCharPtr :: Text -> (Ptr UChar -> Int -> IO a) -> IO a\nwithUCharPtr txt action =\n  BSU.unsafeUseAsCStringLen (TE.encodeUtf16LE txt) $ \\(ptr, lenBytes) ->\n    action (castPtr ptr) (lenBytes `div` 2)\n\nfromUCharPtr :: Ptr UChar -> Int -> IO Text\nfromUCharPtr ptr len = TE.decodeUtf16LE <$> BS.packCStringLen (castPtr ptr, len * 2)\n\ntransliterator :: Text -> IO Transliterator\ntransliterator spec =\n    withUCharPtr spec' \
                --replace-fail $'  (fptr, len) <- asForeignPtr txt\n  withForeignPtr fptr $ \\ptr ->' \
                  $'  withUCharPtr txt $ \\ptr len ->' \
                --replace-fail "fromPtr (castPtr dptr) (fromIntegral dlen)" "fromUCharPtr dptr (fromIntegral dlen)"
            '';
          });
    };
  };
  package =
    haskell.lib.overrideCabal (haskellPackages.callCabal2nix source.pname source.src { })
      (old: {
        installPhase = ''
          runHook preInstall
          install -Dm555 dist/build/dic-nico-intersection-pixiv/dic-nico-intersection-pixiv "$out/bin/dic-nico-intersection-pixiv"
          runHook postInstall
        '';
        patches = [
          ./change-output-directory.patch
        ];
        version = source.version;
      });
in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit (source) pname;
  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    cp "$src" "$out"
    runHook postInstall
  '';
  meta = {
    description = "IME dictionary containing entries shared by Nico Nico Pedia and Pixiv Encyclopedia";
    homepage = "https://github.com/ncaq/dic-nico-intersection-pixiv";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
  name = "${finalAttrs.pname}-${finalAttrs.version}.txt";
  passthru.updateScript = package.overrideAttrs (
    _: _: {
      meta.mainProgram = "dic-nico-intersection-pixiv";
      outputs = [
        "out"
      ];
    }
  );
  src = ./dic-nico-intersection-pixiv-google.txt;
  version = "2026-06-01";
})
