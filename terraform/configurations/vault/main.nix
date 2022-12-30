{...}: let
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

    nomad_cluster = {
      name = "nomad-cluster";
      policy = builtins.readFile ./policies/nomad-cluster.hcl;
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
    "kv-v2" = {
      path = "kv-v2";
      type = "kv-v2";
    };

    "transit" = {
      path = "transit";
      type = "transit";
    };
  };
}
