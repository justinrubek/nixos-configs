let
  ulaPrefix = "fd00:9745:a08b:01e6";
in {
  systemd.network = {
    netdevs."20-br-lan".netdevConfig = {
      Kind = "bridge";
      Name = "br-lan";
    };
    networks = let
      mkLan = Name: {
        linkConfig.RequiredForOnline = "enslaved";
        matchConfig = {inherit Name;};
        networkConfig = {
          Bridge = "br-lan";
          ConfigureWithoutCarrier = true;
        };
      };
    in {
      # ports
      "30-lan0" = mkLan "enp1s0f1";
      "30-lan1" = mkLan "enp2s0";
      "30-lan2" = mkLan "enp3s0";
      # bridge
      "10-br-lan" = {
        address = [
          "10.0.0.1/8"
          "${ulaPrefix}::1/64"
        ];
        bridgeConfig = {};
        ipv6Prefixes = [
          {
            AddressAutoconfiguration = true;
            Assign = true;
            OnLink = true;
            Prefix = "${ulaPrefix}::/64";
          }
        ];
        linkConfig.RequiredForOnline = "no";
        matchConfig.Name = "br-lan";
        networkConfig = {
          ConfigureWithoutCarrier = true;
          DHCPPrefixDelegation = true;
          IPv6SendRA = true;
          IPv6AcceptRA = false;
        };
      };
    };
  };
}
