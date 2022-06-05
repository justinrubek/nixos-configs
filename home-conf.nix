{ system, nixpkgs, nurpkgs, home-manager, overlays, ... }:
let
  username = "justin";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    config.xdg.configHome = configHome;
    overlays = [ nurpkgs.overlay ] ++ overlays;
  };

  nur = import nurpkgs {
    inherit pkgs;
    nurpkgs = pkgs;
  };
in {
  main = home-manager.lib.homeManagerConfiguration rec {
    inherit pkgs system username homeDirectory;

    stateVersion = "22.05";
    configuration = import ./home.nix {
      inherit nur pkgs;
      inherit (pkgs) config lib stdenv;
      inherit username;
    };
  };
}
