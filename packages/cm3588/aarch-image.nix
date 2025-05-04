{
  stdenv,
  zstd,
  image,
}:
stdenv.mkDerivation {
  name = "aarch64-image";
  src = image;
  preferLocalBuild = true;
  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  # Performance
  dontPatchELF = true;
  dontStrip = true;
  noAuditTmpdir = true;
  dontPatchShebangs = true;

  nativeBuildInputs = [
    zstd
  ];

  installPhase = ''
    # Find the zst file using glob pattern
    IMAGE_FILE=$(find $src/sd-image -name "*.img.zst" -type f | head -n 1)
    if [ -z "$IMAGE_FILE" ]; then
      echo "No .img.zst file found in $src/sd-image" >&2
      exit 1
    fi

    echo "Found image file: $IMAGE_FILE"
    zstdcat "$IMAGE_FILE" > $out
  '';
}
