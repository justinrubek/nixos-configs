{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./bootloader.nix
    ./hardware.nix
  ];

  # Linux kernel
  # TODO: remove allowBroken = true once zfs is fixed
  nixpkgs.config.allowBroken = true;
  boot = {
    # kernelPackages = pkgs.linuxKernel.packages.linux_6_0;
    # kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    # kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;
    # kernelPackages = pkgs.zfs.latestCompatibleLinuxPackages;
    supportedFilesystems = ["zfs" "ext4"];
    # zfs.package = pkgs.zfs_unstable;
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services = {
    displayManager = {
      sddm.enable = true;

      defaultSession = "hyprland";
    };
    flatpak.enable = true;
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };
    xserver.enable = true;
    mullvad-vpn = {
      enable = false;
      # openFirewall = true;
    };
  };

  # personal modules
  justinrubek = {
    windowing = {
      hyprland.enable = true;
      plasma.enable = true;
      river.enable = true;
    };

    graphical.fonts.enable = true;

    sound.enable = true;

    development.containers = {
      enable = true;
      useDocker = false;
    };

    tailscale.enable = true;

    mediahost.enable = true;
  };

  users.groups.mediahost = {};
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    justin = {
      isNormalUser = true;
      description = "Justin";
      extraGroups = ["networkmanager" "wheel" "docker" "input" "systemd-journal"];
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
    pkgs.deluge

    pkgs.rocmPackages.rocm-smi
    pkgs.rocmPackages.rocminfo

    # https://github.com/NixOS/nixpkgs/issues/271483#issuecomment-1838055011
    pkgs.pkgsi686Linux.gperftools
  ];

  # Enable networking
  networking = {
    networkmanager = {
      enable = true;
      wifi.scanRandMacAddress = false;
    };
    firewall.allowedTCPPorts = [8000];
    firewall.interfaces.${config.services.tailscale.interfaceName} = {
      allowedTCPPorts = [
        3000
        8000
      ];
    };
  };
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

  programs = {
    gamescope.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession = {
        enable = true;
        args = [
          "-w 2560"
          "-h 1440"
        ];
      };

      package = pkgs.steam.override {
        extraPkgs = pkgs: [
          pkgs.xorg.libXcursor
          pkgs.xorg.libXi
          pkgs.xorg.libXinerama
          pkgs.libpng
          pkgs.libpulseaudio
          pkgs.libvorbis
          pkgs.stdenv.cc.cc.lib
          pkgs.libkrb5
          pkgs.keyutils
        ];
      };
    };
    zsh.enable = true;
  };

  # enable fix for steam issues with xdg-desktop-portal
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  hardware.ckb-next.enable = true;

  # allow swaylock to verify login
  security.pam.services.swaylock.text = "auth include login";
  security.pam.services.hyprlock.text = "auth include login";

  boot.binfmt.emulatedSystems = ["aarch64-linux"];
}
