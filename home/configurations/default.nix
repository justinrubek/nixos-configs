{inputs, ...}: let
  extraModules = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
in {
  justinrubek.homeConfigurations = {
    "justin@manusya" = {
      system = "x86_64-linux";
      modules =
        extraModules
        ++ [
          {
            home.stateVersion = "22.05";
          }
        ];
    };

    "justin@eunomia" = {
      system = "x86_64-linux";
      modules =
        extraModules
        ++ [
          {
            home.stateVersion = "22.11";
          }
        ];
    };

    "justin@bunky" = {
      system = "x86_64-linux";
      modules =
        extraModules
        ++ [
          {
            home.stateVersion = "21.11";
          }
        ];
    };

    "justin@pyxis" = {
      system = "x86_64-linux";
      modules =
        extraModules
        ++ [
          {
            home.stateVersion = "21.11";
          }
        ];
    };

    "justin@ceylon" = {
      system = "x86_64-linux";
      modules =
        extraModules
        ++ [
          {
            home.stateVersion = "21.11";
          }
        ];
    };

    "justin@huginn" = {
      system = "x86_64-linux";
      modules =
        extraModules
        ++ [
          {
            home.stateVersion = "21.11";
          }
        ];
    };

    "justin@alex" = {
      system = "x86_64-linux";
      modules =
        extraModules
        ++ [
          {
            home.stateVersion = "21.11";
          }
        ];
    };
  };
}
