{...}: let
in {
  # configure hcloud
  provider = {
    vault = {};
    consul = {
      datacenter = "dc1";
    };
  };

  data.consul_acl_policy.management.name = "global-management";

  resource.consul_acl_token.vault = {
    description = "ACL token for Consul secrets engine in Vault";
    policies = [
      "\${data.consul_acl_policy.management.name}"
    ];
    local = true;
  };

  data.consul_acl_token_secret_id.vault.accessor_id = "\${consul_acl_token.vault.id}";

  resource.vault_consul_secret_backend.consul = {
    path = "consul";
    description = "Manages Consul backend";
    address = "consul:8500";
    token = "\${data.consul_acl_token_secret_id.vault.secret_id}";
    default_lease_ttl_seconds = 3600;
    max_lease_ttl_seconds = 3600;
  };
}
