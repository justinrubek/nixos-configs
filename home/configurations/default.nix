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
                "steam-unwrapped"
                "steam-run"
                "teamspeak3"
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
      ++ builtins.attrValues self.homeModules;

    configurations = {
      "justin@eunomia" = {
        system = "x86_64-linux";
        modules = [
          ({config, ...}: {
            home.file."${config.gtk.gtk2.configLocation}".force = true; # always force .gtkrc-2.0 replacement
          })
        ];
      };
      "justin@surface".system = "x86_64-linux";
    };
  };
}
