{...}: let
in {
  # configure hcloud
  provider.vault = {
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
  };

  resource.vault_auth_backend.userpass = {
    type = "userpass";
  };

  resource.vault_generic_endpoint.justin = {
    depends_on = ["vault_auth_backend.userpass"];
    path = "auth/userpass/users/justin";
    ignore_absent_fields = true;

    data_json = ''      {
            "password": "password",
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
