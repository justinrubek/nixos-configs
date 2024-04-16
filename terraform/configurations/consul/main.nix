_: {
  # configure hcloud
  provider = {
    vault = { };
    consul = {
      datacenter = "dc1";
    };
  };

  ###
  ### Configure Consul ACLs
  ###

  data.consul_acl_policy.management.name = "global-management";
  data.consul_acl_token_secret_id.vault.accessor_id = "\${consul_acl_token.vault.id}";

  resource = {
    consul_acl_token.vault = {
      description = "ACL token for Consul secrets engine in Vault";
      policies = [ "\${data.consul_acl_policy.management.name}" ];
      local = true;
    };

    vault_consul_secret_backend.consul = {
      path = "consul";
      description = "Manages Consul backend";
      address = "127.0.0.1:8500";
      token = "\${data.consul_acl_token_secret_id.vault.secret_id}";
      default_lease_ttl_seconds = 3600;
      max_lease_ttl_seconds = 3600;
    };

    consul_acl_policy = {
      intentions_read = {
        name = "intentions-read";
        rules = ''
          service_prefix "" {
            policy = "read"
          }'';
      };

      app_key_read = {
        name = "key-read";
        rules = ''
          key_prefix "app" {
            policy = "list"
          }'';
      };
    };

    vault_consul_secret_backend_role.app_team = {
      name = "app-team";
      backend = "\${vault_consul_secret_backend.consul.path}";
      policies = [
        "\${consul_acl_policy.intentions_read.name}"
        "\${consul_acl_policy.app_key_read.name}"
      ];
    };

    vault_github_auth_backend.org = {
      organization = "rubek-dev";
      description = "GitHub auth backend for rubek-dev organization";
    };

    vault_policy.app_team = {
      name = "app-team";

      policy = builtins.readFile ./policies/app-team.hcl;
    };

    vault_github_team.app_team = {
      backend = "\${vault_github_auth_backend.org.id}";
      team = "app-team";
      policies = [ "\${vault_policy.app_team.name}" ];
    };

    vault_github_user.justin = {
      backend = "\${vault_github_auth_backend.org.id}";
      user = "justinrubek";
      policies = [ "\${vault_policy.app_team.name}" ];
    };
  };
}
