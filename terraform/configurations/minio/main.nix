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

    scratch_files = {
      bucket = "scratch-files";
    };
  };

  resource.minio_iam_user = {
    nix_cache = {
      name = "nix-cache";
      force_destroy = true;
    };

    justin = {
      name = "justin";
      force_destroy = true;
    };
  };

  resource.minio_iam_service_account = {
    nix_cache = {
      target_user = "\${minio_iam_user.nix_cache.name}";
    };

    justin = {
      target_user = "\${minio_iam_user.justin.name}";
    };
  };

  resource.minio_iam_group = {
    nix-cache = {
      name = "nix-cache";
    };

    justin = {
      name = "justin";
    };
  };

  resource.minio_iam_group_membership = {
    nix-cache = {
      name = "nix-cache";
      group = "\${minio_iam_group.nix-cache.name}";
      users = [
        "\${minio_iam_user.nix_cache.name}"
      ];
    };

    justin = {
      name = "justin";
      group = "\${minio_iam_group.justin.name}";
      users = [
        "\${minio_iam_user.justin.name}"
      ];
    };
  };

  resource.minio_iam_group_policy = {
    read-write-nix-cache = {
      name = "read-write-nix-cache";
      group = "\${minio_iam_group.nix-cache.name}";
      policy = ''
        {
          "Version": "2012-10-17",
          "Statement": [
              {
                  "Effect": "Allow",
                  "Action": [
                      "s3:*"
                  ],
                  "Resource": [
                      "arn:aws:s3:::''${minio_s3_bucket.nix_cache.bucket}/*"
                  ]
              }
          ]
        }
      '';
    };

    # grant all
    justin = {
      name = "justin";
      group = "\${minio_iam_group.justin.name}";
      policy = ''
        {
          "Version": "2012-10-17",
          "Statement": [
              {
                  "Effect": "Allow",
                  "Action": [
                      "s3:*"
                  ],
                  "Resource": [
                      "arn:aws:s3:::*"
                  ]
              }
          ]
        }
      '';
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

    user_justin_access_key = {
      value = "\${minio_iam_service_account.justin.access_key}";
    };

    user_justin_secret_key = {
      value = "\${minio_iam_service_account.justin.secret_key}";
      sensitive = true;
    };
  };
}
