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

  resource.minio_iam_user = {
    nix_cache = {
      name = "nix-cache";
      force_destroy = true;
    };
  };

  resource.minio_iam_service_account = {
    nix_cache = {
      target_user = "\${minio_iam_user.nix_cache.name}";
    };
  };

  # terraform configuration outputs
  output = {
    bucket_nix_cache_name = {
      value = "\${minio_s3_bucket.nix_cache.bucket}";
    };

    user_nix_cache_access_key = {
      value = "\${minio_iam_service_account.nix_cache.access_key}";
    };

    user_nix_cache_secret_key = {
      value = "\${minio_iam_service_account.nix_cache.secret_key}";
      sensitive = true;
    };
  };
}
