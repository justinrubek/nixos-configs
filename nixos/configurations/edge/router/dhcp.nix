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
                data = "10.0.0.1";
                name = "routers";
              }
              {
                data = "10.0.0.1";
                name = "domain-name-servers";
              }
            ];
            pools = [{pool = "10.0.0.100 - 10.0.0.240";}];
            reservations = [
              {
                hw-address = "a0:36:9e:26:99:15";
                ip-address = "10.0.0.50";
              }
            ];
            subnet = "10.0.0.0/8";
          }
        ];
        valid-lifetime = 3600 * 4;
      };
    };
  };
}
