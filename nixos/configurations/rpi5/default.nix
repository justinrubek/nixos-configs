inputs: {
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
  ];
  environment.systemPackages = [inputs.self.packages.aarch64-linux.neovim];
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
  users.users = {
    justin = {
      isNormalUser = true;
      description = "Justin";
      extraGroups = ["networkmanager" "wheel" "docker" "input" "systemd-journal"];
      shell = pkgs.bashInteractive;
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL1Uj62/yt8juK3rSfrVuX/Ut+xzw1Z75KZS/7fOLm6l"];
    };
    root.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL1Uj62/yt8juK3rSfrVuX/Ut+xzw1Z75KZS/7fOLm6l"];
  };
}
