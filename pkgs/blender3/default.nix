{
  addOpenGLRunpath,
  alembic,
  boost183,
  callPackage,
  cmake,
  colladaSupport ? true,
  config,
  cudaPackages ? { },
  cudaSupport ? config.cudaSupport,
  dbus,
  embree,
  expat,
  fetchFromGitHub,
  fetchpatch2,
  fetchurl,
  fetchzip,
  ffmpeg_6,
  fftw,
  fmt_9,
  freetype,
  gettext,
  glew,
  gmp,
  hash,
  hipSupport ? false,
  ilmbase,
  jackaudioSupport ? false,
  jemalloc,
  lib,
  libGL,
  libGLU,
  libdecor,
  libepoxy,
  libffi,
  libgccjit,
  libharu,
  libjack2,
  libjpeg,
  libpng,
  libsamplerate,
  libsndfile,
  libspnav,
  libtiff,
  libwebp,
  libxkbcommon,
  libxml2,
  llvmPackages,
  makeWrapper,
  mesa,
  mold,
  ocl-icd,
  openal,
  opencollada,
  opencolorio,
  openexr_2,
  openimagedenoise,
  openimageio,
  openjpeg,
  openpgl,
  opensubdiv,
  openvdb,
  openxr-loader,
  pcre,
  pkg-config,
  potrace,
  pugixml,
  python310Packages,
  rocmPackages ? { },
  runCommand,
  spaceNavSupport ? true,
  stdenv,
  tbb,
  version,
  wayland,
  wayland-protocols,
  waylandSupport ? true,
  xorg,
  zlib,
  zstd,
}:
let
  inherit (llvmPackages) llvm;
  inherit (python3Packages) numpy python wrapPython;
  inherit (xorg)
    libX11
    libXext
    libXfixes
    libXi
    libXrender
    libXxf86vm
    ;
  alembic' =
    (alembic.override {
      inherit openexr;
    }).overrideAttrs
      (
        final: _: {
          src = fetchFromGitHub {
            hash = "sha256-zs5Ft/bh1ioJLVjKBUhEdLFDKAcfi6k9qGjLe6HksO4=";
            owner = "alembic";
            repo = "alembic";
            rev = final.version;
          };
          version = "1.7.16";
        }
      );
  boost = boost183;
  ffmpeg = ffmpeg_6;
  openexr = openexr_2;
  openimageio' =
    (openimageio.override {
      inherit boost openexr;
      fmt = fmt_9;
    }).overrideAttrs
      (
        final: _: {
          CXXFLAGS = "-Wno-error=array-bounds -Wno-error=dangling-reference -Wno-error=deprecated-declarations";
          src = fetchFromGitHub {
            hash = "sha256-+haCk7dY7dbP7kRxm95JzW5dHTWyPaKyOxzsdOPkgsA=";
            owner = "AcademySoftwareFoundation";
            repo = "OpenImageIO";
            rev = "46d97b2cc41808a3f575a9723cd665aadff258ca";
          };
          version = "2.3.16.1";
        }
      );
  openpgl' = openpgl.overrideAttrs (
    final: _: {
      src = fetchFromGitHub {
        hash = "sha256-dbHmGGiHQkU0KPpQYpY/o0uCWdb3L5namETdOcOREgs=";
        owner = "OpenPathGuidingLibrary";
        repo = "openpgl";
        rev = "v${final.version}";
      };
      version = "0.5.0";
    }
  );
  opensubdiv' = opensubdiv.override {
    inherit cudaSupport;
  };
  openvdb' =
    (openvdb.override {
      inherit boost;
    }).overrideAttrs
      (
        final: _: {
          meta.license = lib.licenses.mpl20;
          src = fetchFromGitHub {
            hash = "sha256-XKH7hqeUu32dIXSB8he9orMQaNCK7LxHSX3oJp9Gbl0=";
            owner = "AcademySoftwareFoundation";
            repo = "openvdb";
            rev = "v${final.version}";
          };
          version = "10.1.0";
        }
      );
  optix = fetchzip {
    hash = "sha256-0max1j4822mchj0xpz9lqzh91zkmvsn4py0r174cvqfz8z8ykjk8";
    url = "https://developer.download.nvidia.com/redist/optix/v7.3/OptiX-7.3.0-Include.zip";
  };
  python3Packages = python310Packages;
in
stdenv.mkDerivation (
  finalAttrs:
  let
    alembic = alembic';
    buildEnv = callPackage ./wrapper.nix {
      blender = finalAttrs.finalPackage;
    };
    openimageio = openimageio';
    openpgl = openpgl';
    opensubdiv = opensubdiv';
    openvdb = openvdb';
  in
  {
    inherit version;
    LD_LIBRARY_PATH = lib.makeLibraryPath [
      gmp
      libgccjit
      libpng
      stdenv.cc.cc.lib
      tbb
      zlib
      zstd
    ];
    NIX_LDFLAGS = lib.optionalString cudaSupport "-rpath ${stdenv.cc.cc.lib}/lib";
    buildInputs =
      [
        alembic
        boost
        expat
        ffmpeg
        fftw
        freetype
        gettext
        glew
        gmp
        ilmbase
        jemalloc
        libGL
        libGLU
        libX11
        libXext
        libXfixes
        libXi
        libXrender
        libXxf86vm
        libepoxy
        libharu
        libjpeg
        libpng
        libsamplerate
        libsndfile
        libtiff
        libwebp
        libxml2
        openal
        opencolorio
        openexr
        openimageio
        openjpeg
        openpgl
        opensubdiv
        openvdb
        openxr-loader
        pcre
        potrace
        pugixml
        python
        stdenv.cc.cc.lib
        tbb
        zlib
        zstd
      ]
      ++ lib.optionals waylandSupport [
        dbus
        libdecor
        libffi
        libxkbcommon
        wayland
        wayland-protocols
      ]
      ++ lib.optionals (!stdenv.isAarch64) [
        embree
        openimagedenoise
      ]
      ++ lib.optional colladaSupport opencollada
      ++ lib.optional cudaSupport cudaPackages.cudatoolkit
      ++ lib.optional jackaudioSupport libjack2
      ++ lib.optional spaceNavSupport libspnav;
    cmakeFlags =
      [
        "-DALEMBIC_INCLUDE_DIR=${lib.getDev alembic}/include"
        "-DALEMBIC_LIBRARY=${lib.getLib alembic}/lib/libAlembic.so"
        "-DCMAKE_LINKER_TYPE=MOLD"
        "-DPYTHON_INCLUDE_DIR=${python}/include/${python.libPrefix}"
        "-DPYTHON_LIBPATH=${python}/lib"
        "-DPYTHON_LIBRARY=${python.libPrefix}"
        "-DPYTHON_NUMPY_INCLUDE_DIRS=${numpy}/${python.sitePackages}/numpy/_core/include"
        "-DPYTHON_NUMPY_PATH=${numpy}/${python.sitePackages}"
        "-DPYTHON_VERSION=${python.pythonVersion}"
        "-DWITH_ALEMBIC=ON"
        "-DWITH_CODEC_FFMPEG=ON"
        "-DWITH_CODEC_SNDFILE=ON"
        "-DWITH_FFTW3=ON"
        "-DWITH_IMAGE_OPENJPEG=ON"
        "-DWITH_INSTALL_PORTABLE=OFF"
        "-DWITH_MOD_OCEANSIM=ON"
        "-DWITH_OPENCOLLADA=${if colladaSupport then "ON" else "OFF"}"
        "-DWITH_OPENCOLORIO=ON"
        "-DWITH_OPENSUBDIV=ON"
        "-DWITH_OPENVDB=ON"
        "-DWITH_PYTHON_INSTALL=OFF"
        "-DWITH_PYTHON_INSTALL_NUMPY=OFF"
        "-DWITH_PYTHON_INSTALL_REQUESTS=OFF"
        "-DWITH_SDL=OFF"
        "-DWITH_TBB=ON"
      ]
      ++ lib.optional jackaudioSupport "-DWITH_JACK=ON"
      ++ lib.optional stdenv.cc.isClang "-DPYTHON_LINKFLAGS="
      ++ lib.optional stdenv.hostPlatform.isAarch64 "-DWITH_CYCLES_EMBREE=OFF"
      ++ lib.optionals cudaSupport [
        "-DOPTIX_ROOT_DIR=${optix}"
        "-DWITH_CYCLES_CUDA_BINARIES=ON"
        "-DWITH_CYCLES_DEVICE_OPTIX=ON"
      ]
      ++ lib.optionals waylandSupport [
        "-DWITH_GHOST_WAYLAND=ON"
        "-DWITH_GHOST_WAYLAND_DBUS=ON"
        "-DWITH_GHOST_WAYLAND_DYNLOAD=OFF"
        "-DWITH_GJOST_WAYLAND_LIBDECOR=ON"
      ];
    env.NIX_CFLAGS_COMPILE = "-I${lib.getDev ilmbase}/include/OpenEXR -I${python}/include/${python.libPrefix}";
    meta = {
      description = "3D Creation/Animation/Publishing System";
      homepage = "https://www.blender.org";
      license =
        with lib.licenses;
        [
          gpl2Plus
        ]
        ++ lib.optional cudaSupport unfree;
      mainProgram = "blender3";
      platforms = lib.platforms.linux;
    };
    nativeBuildInputs =
      [
        cmake
        llvm.dev
        makeWrapper
        mold
        wrapPython
      ]
      ++ lib.optional cudaSupport addOpenGLRunpath
      ++ lib.optional waylandSupport pkg-config;
    passthru = {
      inherit
        alembic
        openimageio
        openpgl
        opensubdiv
        openvdb
        python
        ;
      pythonPackages = python3Packages;
      tests.render = runCommand "${finalAttrs.pname}-test" { } ''
        set -euo pipefail
        export __EGL_VENDOR_LIBRARY_FILENAMES=${mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json
        export LIBGL_DRIVERS_PATH=${mesa.drivers}/lib/dri
        cat <<PYTHON >scene-config.py
        import bpy

        bpy.context.scene.cycles.samples = 32
        if ${if stdenv.isAArch64 then "True" else "False"}:
          bpy.context.scene.cycles.use_denoising = False
        bpy.context.scene.eevee.taa_render_samples = 32
        bpy.context.scene.render.resolution_x = 100
        bpy.context.scene.render.resolution_y = 100
        bpy.context.scene.render.threads = 1
        bpy.context.scene.render.threads_mode = 'FIXED'
        PYTHON
        mkdir "$out"
        for engine in BLENDER_EEVEE CYCLES; do
          echo "Rendering with $engine..."
          "${finalAttrs.finalPackage}/bin/blender3" \
            --background \
            --engine "$engine" \
            --factory-startup \
            --python scene-config.py \
            --python-exit-code 1 \
            --render-frame 1 \
            --render-output "$out/$engine" \
            -noaudio
        done
      '';
      withPackages =
        f:
        let
          packages = f python3Packages;
        in
        buildEnv.override {
          blender = finalAttrs.finalPackage;
          extraModules = packages;
        };
    };
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
    ];
    pname = "blender";
    postFixup = lib.optionalString cudaSupport ''
      for program in "$out/bin/blender3" "$out/bin/.blender3-wrapped"; do
        isELF "$program" || continue
        addOpenGLRunpath "$program"
      done
    '';
    postInstall = ''
      mv "$out/bin/blender"{,3}
      mv "$out/bin/blender"{,3}-thumbnailer
      mv "$out/share/blender/${lib.versions.majorMinor finalAttrs.version}/python"{,-ext}
      mv "$out/share/applications/blender"{,3}.desktop
      sed -i 's/Exec=blender/Exec=blender3/g' "$out/share/applications/blender3.desktop"
      buildPythonPath "$pythonPath"
      wrapProgram "$out/bin/blender3" \
        --add-flags '--python-use-system-env' \
        --prefix PATH : "$program_PATH" \
        --prefix PYTHONPATH : "$program_PYTHONPATH" \
        --set LD_LIBRARY_PATH "${lib.makeLibraryPath finalAttrs.buildInputs}"
    '';
    postPatch =
      ''
        substituteInPlace extern/clew/src/clew.c \
          --replace '"libOpenCL.so"' '"${ocl-icd}/lib/libOpenCL.so"'
      ''
      + lib.optionalString hipSupport ''
        substituteInPlace extern/hipew/src/hipew.c \
          --replace '"/opt/rocm/hip/lib/libamdhip64.so"' '"${rocmPackages.clr}/lib/libamdhip64.so"' \
          --replace '"opt/rocm/hip/bin"' '"${rocmPackages.clr}/bin"'
      '';
    pythonPath = with python3Packages; [
      numpy
      requests
      zstandard
    ];
    src = fetchurl {
      inherit hash;
      url = "https://download.blender.org/source/blender-${finalAttrs.version}.tar.xz";
    };
  }
)
