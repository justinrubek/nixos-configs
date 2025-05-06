{
  inputs,
  inputs',
  lib,
  pkgs,
  self',
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    ./disko.nix
  ];
  boot = {
    supportedFilesystems = ["ext4" "btrfs"];
  };
  documentation.man.generateCaches = lib.mkForce false;

  time.timeZone = "America/Chicago";

  services = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };
  };

  justinrubek = {
    tailscale.enable = false;
  };

  users.users = {
    justin = {
      isNormalUser = true;
      description = "Justin";
      extraGroups = ["networkmanager" "wheel" "input" "systemd-journal"];
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL1Uj62/yt8juK3rSfrVuX/Ut+xzw1Z75KZS/7fOLm6l"];
      shell = pkgs.zsh;
    };
  };

  environment.systemPackages = [
    inputs'.disko.packages.default
    pkgs.tailscale
    self'.packages.neovim
  ];

  networking = {
    networkmanager = {
      enable = true;
      wifi.scanRandMacAddress = false;
    };
    firewall.allowedTCPPorts = [];
    # firewall.interfaces.${config.services.tailscale.interfaceName} = {
    #   allowedTCPPorts = [];
    # };
  };

  system.stateVersion = "22.11";

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        fish_vi_key_bindings
        set -x EDITOR nvim
        set -x VISUAL nvim
      '';
      shellAbbrs.vi = "nvim";
    };
    zsh.enable = true;
  };
  security.sudo.wheelNeedsPassword = false;
}
