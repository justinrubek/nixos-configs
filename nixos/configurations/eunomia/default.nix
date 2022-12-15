{unixpkgs, ...} @ inputs: {
  config,
  pkgs,
  lib,
  ...
}: let
  upkgs = unixpkgs.legacyPackages.x86_64-linux;
in {
  imports = [
  ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Linux kernel
  # TODO: remove allowBroken = true once zfs is fixed
  nixpkgs.config.allowBroken = true;
  boot = {
    # kernelPackages = pkgs.linuxKernel.packages.linux_6_0;
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    supportedFilesystems = ["zfs" "ext4"];
    zfs.enableUnstable = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # personal modules
  justinrubek = {
    windowing.plasma.enable = true;

    sound.enable = true;

    development.containers = {
      enable = true;
    };

    tailscale.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    justin = {
      isNormalUser = true;
      description = "Justin";
      extraGroups = ["networkmanager" "wheel" "docker"];
      shell = pkgs.zsh;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.tailscale
  ];

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
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

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  hardware.ckb-next.enable = true;
}
