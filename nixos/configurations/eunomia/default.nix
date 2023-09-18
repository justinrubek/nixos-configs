{nixpkgs, ...} @ inputs: {
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
  ];

  # Linux kernel
  # TODO: remove allowBroken = true once zfs is fixed
  nixpkgs.config.allowBroken = true;
  boot = {
    # kernelPackages = pkgs.linuxKernel.packages.linux_6_0;
    # kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;
    # kernelPackages = pkgs.zfs.latestCompatibleLinuxPackages;
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
  services.xserver.displayManager = {
    sddm.enable = true;

    defaultSession = "hyprland";
  };

  # personal modules
  justinrubek = {
    windowing.plasma.enable = true;
    windowing.hyprland.enable = true;

    graphical.fonts.enable = true;

    sound.enable = true;

    development.containers = {
      enable = true;
      useDocker = true;
    };

    tailscale.enable = true;

    mediahost.enable = false;
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

  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.tailscale
    pkgs.mullvad-vpn
    pkgs.deluge

    pkgs.rocm-smi
    pkgs.rocminfo
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
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

  # enable fix for steam issues with xdg-desktop-portal
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  hardware.ckb-next.enable = true;

  services.flatpak.enable = true;

  # allow swaylock to verify login
  security.pam.services.swaylock.text = "auth include login";

  services.mullvad-vpn = {
    enable = true;
    # openFirewall = true;
  };

  services.pixiecore = let
    netSystem = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({
          config,
          pkgs,
          lib,
          modulesPath,
          ...
        }: {
          imports = [
            "${inputs.nixpkgs}/nixos/modules/installer/netboot/netboot-minimal.nix"
          ];
          config = {
            users.users.root.openssh.authorizedKeys.keys = [
              "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsUQZGQOH2kmQNeG/Ezmsv6A/70JUO8nLh9WaZ/o7DlmpYeEyUdloTazxpP9FjuRv7d7nzRqtQFOF74TBaDEAxR9/eHxX9zc5RfyE1RYeGWPGgnuHpxoTijh70ncTlU6sr0oqP7e24qeIy7pqWKQmV8RDOkr2etbnb5OpCHEsZJ0l0sPYQpYi0Ud8cM/HFCCVPeg21wVuxBX2rA4ze8+YgnPJZRnhtHZg7rAapvhiIfDAJ3xIweauCoz0vZdmANlUsg2AoOx9b2Ym6rGNmRrJUNZYcsNxmUHc1/oc1g9NZ7GoaMhfw0BHVJ0kyfE2glpJX9iu6WHWjbL+XM0QnCFrc3hbQc41zYQsMHcY/N/P5MW9Gj77Q9P/qRDbwlVOdoFw1bUpIoMgsJ95o5gv5mClHuBLZD3ZO5cyRfnjH4w0pt6EnWtbkORsT5A7ULOQOG8AOuBL3ok/yVTVAFV2yMbaEg1BM2By0U6hn9M6SGWuOiM1oMwvVFJWdmZsvPeTZqaU= justin"
            ];
          };
        })
      ];
    };

    build = netSystem.config.system.build;
  in {
    enable = true;
    mode = "boot";
    openFirewall = true;
    kernel = "${build.kernel}/bzImage";
    initrd = "${build.netbootRamdisk}/initrd";
    cmdLine = "init=${build.toplevel}/init loglevel=4";
    debug = true;
    dhcpNoBind = true;
  };
}
