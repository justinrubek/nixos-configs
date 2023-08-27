{...}: let
  kv_v2_path = "kv-v2";
in {
  # configure hcloud
  provider = {
    vault = {};

    sops = {};
  };

  data.sops_file.vault_admin = {
    source_file = "../../../secrets/vault/admin.yaml";
  };

  locals = {
    vault_admin = ''''${data.sops_file.vault_admin.data["default_password"]}'';
  };

  resource.vault_policy = {
    admin_policy = {
      name = "admins";
      policy = builtins.readFile ./policies/admins.hcl;
    };

    eaas_client = {
      name = "eaas-client";
      policy = builtins.readFile ./policies/eaas-client.hcl;
    };

    nomad_server = {
      name = "nomad-server";
      policy = builtins.readFile ./policies/nomad-server.hcl;
    };

    hello = {
      name = "hello";
      policy = builtins.readFile ./policies/hello.hcl;
    };

    calendar_client = {
      name = "calendar-client";
      policy = builtins.readFile ./policies/calendar-client.hcl;
    };

    github_actions = {
      name = "github-actions-secrets";
      policy = builtins.readFile ./policies/github-actions-secrets.hcl;
    };

    factorio_server = {
      name = "factorio-server";
      policy = builtins.readFile ./policies/factorio-server.hcl;
    };

    nix_cache_postgres = {
      name = "nix-cache-postgres";
      policy = builtins.readFile ./policies/nix-cache-postgres.hcl;
    };

    nix_cache_attic = {
      name = "nix-cache-attic";
      policy = builtins.readFile ./policies/nix-cache-attic.hcl;
    };
  };

  resource.vault_auth_backend.userpass = {
    type = "userpass";
  };

  resource.vault_generic_endpoint.admin = {
    depends_on = ["vault_auth_backend.userpass"];
    path = "auth/userpass/users/admin";
    ignore_absent_fields = true;

    data_json = ''      {
            "password": "''${local.vault_admin}",
            "policies": ["admins", "eaas-client"]
          }'';
  };

  resource.vault_mount = {
    ${kv_v2_path} = {
      path = kv_v2_path;
      type = kv_v2_path;
    };

    "transit" = {
      path = "transit";
      type = "transit";
    };

    "database" = {
      path = "database";
      type = "database";
    };
  };

  # token auth backend
  # https://developer.hashicorp.com/nomad/docs/integrations/vault-integration#vault-token-role-configuration
  resource.vault_token_auth_backend_role.nomad_cluster = {
    role_name = "nomad-cluster";

    disallowed_policies = ["nomad-server"];
    token_explicit_max_ttl = "0";
    orphan = true;
    token_period = "259200";
    renewable = true;
  };

  # https://developer.hashicorp.com/nomad/tutorials/integrate-vault/vault-postgres?in=nomad%2Fintegrate-vault#configure-the-database-secrets-engine
  # resource.vault_database_secret_backend_connection.postgres = {
  #   backend = "database";
  #   name = "postgres";
  #   allowed_roles = ["accessdb"];

  #   postgresql = {
  # TODO: get service URL. How to deal with SRV records?
  #     connection_url = "postgresql://{{username}}:{{password}}@postgres.service.consul/postgres?sslmode=disable";
  #     username = "postgres";
  #     password = "postgres123";
  #   };
  # };

  # terraform configuration outputs
  output = {
    kv_v2_path = {
      value = kv_v2_path;
    };
  };
}
