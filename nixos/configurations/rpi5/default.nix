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
  users.users.root.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL1Uj62/yt8juK3rSfrVuX/Ut+xzw1Z75KZS/7fOLm6l"];
}
