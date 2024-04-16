{ nixpkgs, ... }@inputs:
{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./bootloader.nix
    ./hardware.nix
  ];

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };
    printing.enable = true;
    xserver.enable = true;
  };

  # personal modules
  justinrubek = {
    windowing.plasma.enable = true;

    sound.enable = true;

    development.containers.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    justin = {
      isNormalUser = true;
      description = "Justin";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  wget
    firefox
    kate
    vim
    git
    alsa-lib
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leavecatenate(variables, "bootdev", bootdev)
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  networking = {
    networkmanager.enable = true;

    nameservers = [
      "1.1.1.1"
      "9.9.9.9"
    ];
    firewall.allowedTCPPorts = [
      8080
      8081
    ];
  };

  hardware.ckb-next.enable = true;
}
