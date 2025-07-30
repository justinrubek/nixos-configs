{
  systemd.network = {
    netdevs."20-br-lan".netdevConfig = {
      Kind = "brdige";
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
          "172.16.0.1/24"
        ];
        bridgeConfig = {};
        linkConfig.RequiredForOnline = "no";
        matchConfig.Name = "br-lan";
        networkConfig.ConfigureWithoutCarrier = true;
      };
    };
  };
}
