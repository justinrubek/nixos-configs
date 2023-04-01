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

  # Linux kernel
  # TODO: remove allowBroken = true once zfs is fixed
  nixpkgs.config.allowBroken = true;
  boot = {
    # kernelPackages = pkgs.linuxKernel.packages.linux_6_0;
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    supportedFilesystems = ["zfs" "ext4"];
    zfs.enableUnstable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;

  # personal modules
  justinrubek = {
    # windowing.plasma.enable = true;
    windowing.hyprland.enable = true;

    graphical.fonts.enable = true;

    sound.enable = true;

    development.containers = {
      enable = true;
      useDocker = true;
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
    pkgs.mullvad-vpn
  ];

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # networking.useNetworkd = false;
  # systemd.network = {
  #   enable = true;
  #   networks.default = {
  #     matchConfig.Name = "en*";
  #     networkConfig.DHCP = "yes";
  #   };
  # };

  # Open ports in the firewall.

  # networking.firewall.allowedTCPPorts = [ ... ];
  networking.firewall.allowedTCPPorts = [8000];
  networking.firewall.interfaces.${config.services.tailscale.interfaceName} = {
    allowedTCPPorts = [
      3000
      8000
      # grocy
      6100
    ];
  };

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

  services.grocy = {
    enable = true;

    hostName = "grocy.localhost";
    nginx.enableSSL = false;
  };
  # changing grocy port forcibly
  services.nginx.virtualHosts."grocy.localhost" = {
    listen = [
      {
        addr = "0.0.0.0";
        port = 6100;
      }
    ];
  };

  services.flatpak.enable = true;

  # allow swaylock to verify login
  security.pam.services.swaylock.text = "auth include login";

  services.mullvad-vpn = {
    enable = true;
    # openFirewall = true;
  };
}
