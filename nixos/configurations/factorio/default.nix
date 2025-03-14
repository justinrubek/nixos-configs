{
  config,
  pkgs,
  lib,
  inputs',
  ...
}: {
  imports = [
    ./hardware.nix
  ];

  # Linux kernel

  # Enable networking
  # networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

  justinrubek = {
    services.vintagestory.enable = true;
    tailscale = {
      enable = true;
      autoconnect.enable = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    justin = {
      isNormalUser = true;
      description = "Justin";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL1Uj62/yt8juK3rSfrVuX/Ut+xzw1Z75KZS/7fOLm6l justin@eunomia"
      ];
    };
  };

  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  # services.openssh = {
  #   enable = true;
  #   permitRootLogin = "no";
  # };

  # rpc.statd fix
  services = {
    nfs.server.enable = true;
    factorio = {
      enable = true;
      package = inputs'.factorio-server.packages.factorio-headless;
      admins = ["justinkingr"];
      autosave-interval = 2;
      game-name = "I used to have a family, now I have a factory";
      game-password = "UG"; # TODO: change this
      lan = false;
      loadLatestSave = true;
      nonBlockingSaving = true;
      openFirewall = true;
      port = 34500;
      saveName = "first-space-age";
    };
  };

  # Open ports in the firewall.
  networking.firewall.interfaces.${config.services.tailscale.interfaceName} = {
    allowedUDPPorts = [34500];
  };

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leavecatenate(variables, "bootdev", bootdev)
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
