{
  services.kea = {
    dhcp4 = {
      enable = true;
      settings = {
        control-socket = {
          socket-name = "/var/run/kea/kea-dhcp4.sock";
          socket-type = "unix";
        };
        interfaces-config.interfaces = ["br-lan"];
        lease-database = {
          name = "/var/lib/kea/dhcp4.leases";
          persist = true;
          type = "memfile";
        };
        renew-timer = 3600;
        rebind-timer = 3600 * 2;
        subnet4 = [
          {
            id = 100;
            option-data = [
              {
                data = "172.16.0.1";
                name = "routers";
              }
              {
                data = "172.16.0.1";
                name = "domain-name-servers";
              }
            ];
            pools = [{pool = "172.16.0.100 - 172.16.0.240";}];
            subnet = "172.16.0.0/24";
          }
        ];
        valid-lifetime = 3600 * 4;
      };
    };
  };
}
