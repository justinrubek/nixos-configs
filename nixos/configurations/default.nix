{
  inputs,
  self,
  ...
}: {
  imports = [
    inputs.config-parts.flakeModules.nixos
  ];

  config-parts.nixos = {
    modules.shared =
      [
        {
          boot.tmp.cleanOnBoot = true;
          caches.enable = true;
          documentation.man = {
            enable = true;
            generateCaches = true;
          };
          i18n.extraLocaleSettings = {
            LC_TIME = "en_GB.UTF-8";
          };
          nix.settings.trusted-users = ["@wheel"];
        }
        inputs.hyprland.nixosModules.default
        inputs.sops-nix.nixosModules.sops
      ]
      ++ builtins.attrValues self.nixosModules;

    configurations = {
      eunomia.system = "x86_64-linux";
      surface.system = "x86_64-linux";
      rpi5.system = "aarch64-linux";
    };
  };
}
