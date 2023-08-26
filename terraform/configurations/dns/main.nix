{...}: {
  # configure hcloud
  provider = {
    vault = {};
    porkbun = {
      api_key = "\${data.vault_kv_secret_v2.porkbun_key.data.api_key}";
      secret_key = "\${data.vault_kv_secret_v2.porkbun_key.data.secret_key}";
    };
  };

  data.vault_kv_secret_v2.porkbun_key = {
    mount = "kv-v2";
    name = "dns/porkbun";
  };

  resource.porkbun_dns_record.dummy_api = {
    domain = "rubek.cloud";
    # TODO: wildcard?
    name = "dummy-api";
    type = "A";

    # TODO: pull this in from the outputs of another configuration
    content = "5.78.58.3";
  };
}
