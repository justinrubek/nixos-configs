{
  home-manager,
  unixpkgs,
  nurpkgs,
  nixvim,
  self,
  ...
} @ inputs: username: hostname: system: nixpkgs: let
  args = inputs;
  entrypoint = import "${self}/home/configurations/${username}@${hostname}" inputs;
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";
  pkgs = import unixpkgs {
    inherit system;
    config.allowUnfree = true;
    config.xdg.configHome = configHome;
    overlays = [nurpkgs.overlay];
  };
in
  home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    modules =
      [
        entrypoint
        {
          home = {
            stateVersion = "22.05";
            inherit username homeDirectory;
          };
        }
        nixvim.homeManagerModules.nixvim
      ]
      ++ __attrValues self.homeModules;

    extraSpecialArgs = {
      username = username;
    };
  }
