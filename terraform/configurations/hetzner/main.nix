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

    server_type = "cpx31";
    # inherit server_type;
    inherit location image;
    inherit public_net;
  };

  resource.hcloud_server.huginn = {
    name = "huginn";

    inherit server_type location image;
    inherit public_net;
  };

  resource.hcloud_firewall.load_balancer = {
    name = "allow_http";

    rule = [
      {
        direction = "in";
        protocol = "tcp";
        port = "80";
        source_ips = [
          "0.0.0.0/0"
          "::/0"
        ];
      }
      {
        direction = "in";
        protocol = "tcp";
        port = "443";
        source_ips = [
          "0.0.0.0/0"
          "::/0"
        ];
      }
    ];
  };

  resource.hcloud_firewall_attachment.http_firewall = {
    firewall_id = "\${hcloud_firewall.load_balancer.id}";
    server_ids = [
      "\${hcloud_server.huginn.id}"
    ];
  };

  ### NFS

  resource.hcloud_server.alex = {
    name = "alex";

    inherit server_type location image;
    inherit public_net;
  };

  resource.hcloud_volume.persist = {
    name = "persist";
    size = 50;
    location = "hil";
  };

  resource.hcloud_volume_attachment.nfs = {
    server_id = "\${hcloud_server.alex.id}";
    volume_id = "\${hcloud_volume.persist.id}";
    automount = false;
  };

  output = {
    host_addresses = {
      value = {
        bunky = "\${hcloud_server.bunky.ipv4_address}";
        pyxis = "\${hcloud_server.pyxis.ipv4_address}";
        ceylon = "\${hcloud_server.ceylon.ipv4_address}";
        huginn = "\${hcloud_server.huginn.ipv4_address}";
        alex = "\${hcloud_server.alex.ipv4_address}";
      };
    };

    host_addresses_ipv6 = {
      value = {
        bunky = "\${hcloud_server.bunky.ipv6_address}";
        pyxis = "\${hcloud_server.pyxis.ipv6_address}";
        ceylon = "\${hcloud_server.ceylon.ipv6_address}";
        huginn = "\${hcloud_server.huginn.ipv6_address}";
        alex = "\${hcloud_server.alex.ipv6_address}";
      };
    };
  };
}
