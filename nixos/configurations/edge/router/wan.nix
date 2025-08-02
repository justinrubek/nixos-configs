{
  systemd.network = {
    networks = {
      "20-wan" = {
        linkConfig.RequiredForOnline = "routable";
        matchConfig.Name = "enp1s0f0";
        networkConfig = {
          # BindCarrier = ["enp1s0f0"];
          DHCP = "yes";
          DNSOverTLS = true;
          DNSSEC = true;
          IPv4Forwarding = true;
          IPv6AcceptRA = true;
          IPv6Forwarding = true;
        };
      };
    };
  };
}
