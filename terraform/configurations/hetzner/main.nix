{...}: let
  server_type = "cpx11";
  location = "hil";
  image = "\${data.hcloud_image.nixos_base.id}";

  public_net = {
    ipv4_enabled = true;
    ipv6_enabled = true;
  };
in {
  # configure hcloud
  variable.hcloud_token.sensitive = true;
  provider.hcloud.token = "\${var.hcloud_token}";

  data.hcloud_image.nixos_base = {
    id = "92487340";
  };

  resource.hcloud_server.bunky = {
    name = "bunky";

    inherit server_type location image;
    inherit public_net;

    # backups = true;
  };

  resource.hcloud_server.pyxis = {
    name = "pyxis";

    inherit server_type location image;
    inherit public_net;
  };

  resource.hcloud_server.ceylon = {
    name = "ceylon";

    inherit server_type location image;
    inherit public_net;
  };
}
