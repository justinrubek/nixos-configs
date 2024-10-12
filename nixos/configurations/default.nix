{
  inputs,
  self,
  ...
}: let
  sshModule = {
    justinrubek.administration = {
      enable = true;
    };
  };
in {
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
      ++ builtins.attrValues self.nixosModules
      ++ builtins.attrValues self.modules;

    configurations = {
      # physical machines
      eunomia.system = "x86_64-linux";
      surface.system = "x86_64-linux";
      rpi5.system = "aarch64-linux";

      # cloud servers
      bunky = {
        system = "x86_64-linux";
        modules = [sshModule];
      };
      pyxis = {
        system = "x86_64-linux";
        modules = [sshModule];
      };
      ceylon = {
        system = "x86_64-linux";
        modules = [sshModule];
      };
      huginn = {
        system = "x86_64-linux";
        modules = [sshModule];
      };
      alex = {
        system = "x86_64-linux";
        modules = [sshModule];
      };

      # other
      hetzner-base = {
        system = "x86_64-linux";
        modules = [sshModule];
      };
    };
  };
}
