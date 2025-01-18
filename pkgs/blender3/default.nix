{
  assetsHash,
  blender,
  boost183,
  fetchFromGitHub,
  fetchgit,
  fetchpatch2,
  fetchzip,
  ffmpeg_6,
  lib,
  openpgl,
  openvdb,
  python310Packages,
  sourceHash,
  stdenv,
  version,
}:
let
  openpgl-0_5 = openpgl.overrideAttrs (_: {
    src = fetchFromGitHub {
      hash = "sha256-dbHmGGiHQkU0KPpQYpY/o0uCWdb3L5namETdOcOREgs=";
      owner = "OpenPathGuidingLibrary";
      repo = "openpgl";
      rev = "v0.5.0";
    };
    version = "0.5.0";
  });
  openvdb_10 =
    (openvdb.override {
      boost = boost183;
    }).overrideAttrs
      (old: rec {
        meta = old.meta // {
          license = lib.licenses.mpl20;
        };
        name = "${old.pname}-${version}";
        src = fetchFromGitHub {
          hash = "sha256-XKH7hqeUu32dIXSB8he9orMQaNCK7LxHSX3oJp9Gbl0=";
          owner = "AcademySoftwareFoundation";
          repo = "openvdb";
          rev = "v${version}";
        };
        version = "10.1.0";
      });
in
(blender.override {
  ffmpeg = ffmpeg_6;
  openpgl = openpgl-0_5;
  openvdb_11 = openvdb_10;
  python3Packages = python310Packages;
}).overrideAttrs
  (
    final: prev: {
      inherit version;
      patches = [
        ./draco.patch
        (fetchpatch2 {
          hash = "sha256-YXXqP/+79y3f41n3cJ3A1RBzgdoYqfKZD/REqmWYdgQ=";
          url = "https://gitlab.archlinux.org/archlinux/packaging/packages/blender/-/raw/4b6214600e11851d7793256e2f6846a594e6f223/ffmpeg-7-1.patch";
        })
        (fetchpatch2 {
          hash = "sha256-mF6IA/dbHdNEkBN5XXCRcLIZ/8kXoirNwq7RDuLRAjw=";
          url = "https://gitlab.archlinux.org/archlinux/packaging/packages/blender/-/raw/4b6214600e11851d7793256e2f6846a594e6f223/ffmpeg-7-2.patch";
        })
      ] ++ lib.optional stdenv.hostPlatform.isDarwin ./darwin.patch;
      preConfigure = ''
        expected_python_version=$(grep -E --only-matching 'SET\(_PYTHON_VERSION_SUPPORTED [0-9.]+\)' build_files/cmake/Modules/FindPythonLibsUnix.cmake | grep -E --only-matching '[0-9.]+')
        actual_python_version=$(python -c 'import sys; print(".".join(map(str, sys.version_info[0:2])))')
        if ! [[ "$actual_python_version" = "$expected_python_version" ]]; then
          echo "wrong Python version, expected '$expected_python_version', got '$actual_python_version'" >&2
          exit 1
        fi
      '';
      srcs = [
        (fetchzip {
          hash = sourceHash;
          name = "source";
          url = "https://download.blender.org/source/blender-${version}.tar.xz";
        })
        (fetchgit {
          fetchLFS = true;
          hash = assetsHash;
          name = "assets";
          rev = "v${version}";
          url = "https://projects.blender.org/blender/blender-assets.git";
        })
      ];
    }
  )
