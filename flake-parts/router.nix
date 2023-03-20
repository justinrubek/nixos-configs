{
  inputs,
  self,
  lib,
  ...
}: {
  imports = [];

  perSystem = {
    self',
    pkgs,
    lib,
    system,
    inputs',
    ...
  }: let
    profiles = inputs.openwrt-imagebuilder.lib.profiles {inherit pkgs;};

    config =
      profiles.identifyProfile "asus_rt-ac58u"
      // {
        packages = ["tcpdump"];
        disabledServices = ["dnsmasq"];

        files = pkgs.runCommand "image-fileS" {} ''
          mkdir -p $out/etc/uci-defaults
          cat > $out/etc/uci-defaults/99-custom <<EOF
          uci -q batch << EOI
          set system.@system[0].hostname='testap'
          commit
          EOI
          EOF
        '';
      };
  in {
    packages = {
      router = inputs.openwrt-imagebuilder.lib.build config;
    };
  };
}
