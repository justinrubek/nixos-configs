{...}: {
  # configure hcloud
  variable.hcloud_token.sensitive = true;
  provider.hcloud.token = "\${var.hcloud_token}";

  data.hcloud_image.nixos_base = {
    id = "92487340";
  };

  resource.hcloud_server.bunky = {
    name = "bunky";

    image = "\${data.hcloud_image.nixos_base.id}";
    server_type = "cpx11";
    location = "hil";

    public_net = {
      ipv4_enabled = true;
      ipv6_enabled = true;
    };

    # backups = true;
  };
}
