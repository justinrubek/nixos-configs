{
  inputs,
  lib,
  self,
  ...
}: {
  imports = [
    inputs.config-parts.flakeModules.home
  ];

  config-parts.home = {
    modules.shared =
      [
        ({config, ...}: {
          nixpkgs = {
            config.allowUnfreePredicate = pkg:
              builtins.elem (lib.getName pkg) [
                "discord"
                "dwarf-fortress"
                "slack"
                "steam"
                "steam-original"
                "steam-run"
                "teamspeak-client"
                "teamspeak5-client"
                "zoom"
              ];
          };
          xdg.configHome = "${config.home.homeDirectory}/.config";
        })
        {disabledModules = ["services/hyprland.nix"];}
        inputs.hyprland.homeManagerModules.default
        inputs.global-keybind.homeModules.global-keybind
      ]
      ++ builtins.attrValues self.homeModules
      ++ builtins.attrValues self.modules;

    configurations = {
      "justin@manusya".system = "x86_64-linux";
      "justin@eunomia" = {
        system = "x86_64-linux";
        modules = [
          ({config, ...}: {
            home.file."${config.gtk.gtk2.configLocation}".force = true; # always force .gtkrc-2.0 replacement
          })
        ];
      };
      "justin@bunky".system = "x86_64-linux";
      "justin@pyxis".system = "x86_64-linux";
      "justin@ceylon".system = "x86_64-linux";
      "justin@huginn".system = "x86_64-linux";
      "justin@alex".system = "x86_64-linux";
      "justin@surface".system = "x86_64-linux";
    };
  };
}
