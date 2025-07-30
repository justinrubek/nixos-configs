{pkgs, ...}: {
  services = {
    resolved.enable = false;
    unbound = {
      enable = true;
      package = pkgs.unbound-full;
      resolveLocalQueries = true;
      settings = {
        forward-zone = [
          {
            name = ".";
            forward-addr = [
              "10.1.1.1@53#openwrt"
              "1.1.1.1@853#cloudflare-dns.com"
              "1.0.0.1@853#cloudflare-dns.com"
              "8.8.8.8@853#dns.google"
              "8.8.4.4@853#dns.google"
            ];
            forward-first = false;
            forward-tls-upstream = true;
          }
        ];
        remote-control = {
          control-enable = true;
          control-interface = "/var/run/unbound/unbound.sock";
        };
        server = {
          access-control = [
            "0.0.0.0/0 refuse"
            "127.0.0.0/8 allow"
            "192.168.0.0/16 allow"
            "172.16.0.0/12 allow"
            "10.0.0.0/8 allow"
            "::0/0 refuse"
            "::1 allow"
          ];
          extended-statistics = true;
          interface = [
            "10.0.0.1"
            "127.0.0.1"
          ];
          root-hints = "${pkgs.dns-root-data}/root.hints";
        };
      };
    };
  };
}
