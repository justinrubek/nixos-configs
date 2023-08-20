{...}: {
  provider = {
    minio = {};
  };

  locals = {
  };

  resource.minio_s3_bucket = {
    nix_cache = {
      bucket = "nix-cache";
    };
  };

  # terraform configuration outputs
  output = {
    bucket_nix_cache_name = {
      value = "\${minio_s3_bucket.nix_cache.bucket}";
    };
  };
}
