{
  nomadJobs,
  pkgs,
  ...
}: let
  system = pkgs.system;

  nomad_jobs = nomadJobs;
in {
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
    name = "secret/porkbun/api_key";
  };

  resource.porkbun_dns_record.dummy_api = {
    domain = "rubek.cloud";
    name = "dummy-api";
    type = "A";

    content = "5.78.58.3";
  };
}
