{
  networking = {
    firewall.enable = false;
    nftables = {
      enable = true;
      # pre-check is impure, so check errors on the local machine
      # https://discourse.nixos.org/t/nftables-could-not-process-rule-no-such-file-or-directory/33031/5
      preCheckRuleset = ''
        sed 's/.*devices.*/devices = { lo }/g' -i ruleset.conf
        sed -i '/flags offload;/d' -i ruleset.conf
      '';
      tables = {
        "filter" = {
          content = ''
            chain input {
              type filter hook input priority 0; policy drop;

              iifname "br-lan" accept comment "allow local network to access router"
              iifname "enp1s0f0" ct state { established, related } accept comment "allow established traffic"
              iifname "enp1s0f0" counter drop comment "drop all other traffic as unsolicited"
              iifname "lo" accept comment "accept traffic from loopback"
            }
            chain forward {
              type filter hook forward priority filter; policy drop;

              iifname "br-lan" oifname "enp1s0f0" accept comment "allow lan to wan as trusted"
              iifname "enp1s0f0" oifname "br-lan" ct state { established, related accept comment "allow established traffic"
              iifname "enp1s0f0" oifname "br-lan" ct status dnat accept comment "allow nat from wan"
            }
          '';
          family = "inet";
        };
        "nat" = {
          content = ''
            chain prerouting {
              type nat hook prerouting priority -100;

              iifname "bond-wan" ip protocol tcp tcp dport 443 dnat to 172.16.0.2:443 "nat traffic from wan to webserver"
            }
            chain postrouting {
              type nat hook postrouting priority 100; policy accept;

              ip saddr 172.16.0.0/24 oifname "bond-wan" masquerade comment "masquerade private ip addresses"
            }
          '';
          family = "ip";
        };
      };
    };
  };
}
