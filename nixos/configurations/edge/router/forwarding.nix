{
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = 1;
    # deny martian packets
    "net.ipv4.conf.enp1s0f0.rp_filter" = 1;
    "net.ipv4.conf.br-lan.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    # no ipv6 yet
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.all.autoconf" = 0;
    "net.ipv6.conf.all.forwarding" = 0;
    "net.ipv6.conf.all.use_tempaddr" = 0;
  };
}
