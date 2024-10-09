{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
  ];
  boot.kernelModules = ["i2c-dev"];
  documentation.man.generateCaches = lib.mkForce false;
  environment.systemPackages = [self.packages.aarch64-linux.neovim pkgs.git];
  justinrubek = {
    administration.enable = true;
    tailscale.enable = true;
  };
  networking.firewall = {
    allowedTCPPorts = [22];
    interfaces.${config.services.tailscale.interfaceName} = {
      allowedTCPPorts = [22];
    };
  };
  raspberry-pi-nix.libcamera-overlay.enable = false;
  system.stateVersion = "24.11";
  users.users = {
    justin = {
      isNormalUser = true;
      description = "Justin";
      extraGroups = ["networkmanager" "wheel" "docker" "input" "systemd-journal" "video"];
      shell = pkgs.bashInteractive;
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL1Uj62/yt8juK3rSfrVuX/Ut+xzw1Z75KZS/7fOLm6l"];
    };
    root.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL1Uj62/yt8juK3rSfrVuX/Ut+xzw1Z75KZS/7fOLm6l"];
  };
}
