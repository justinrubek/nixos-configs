{
  config,
  pkgs,
  inputs,
  inputs',
  lib,
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
      sddm = {
        enable = true;
        wayland.enable = true;
      };

      defaultSession = "hyprland";
    };
    flatpak.enable = true;
    home-assistant = {
      enable = true;
      extraComponents = [
        "airgradient"
        "air_quality"
        "default_config"
        "esphome"
        "met"
        "radio_browser"
      ];
      config = {
        default_config = {};
        homeassistant = {
          name = "home";
          unit_system = "metric";
          time_zone = "America/Chicago";
        };
      };
      customComponents = [pkgs.home-assistant-custom-components.garmin_connect];
    };
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };
    pixiecore = let
      sys = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({
            config,
            pkgs,
            lib,
            modulesPath,
            ...
          }: {
            imports = [(modulesPath + "/installer/netboot/netboot-minimal.nix")];
            config = {
              services.openssh = {
                enable = true;
                openFirewall = true;

                settings = {
                  PasswordAuthentication = false;
                  KbdInteractiveAuthentication = false;
                };
              };
              users.users.root.openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL1Uj62/yt8juK3rSfrVuX/Ut+xzw1Z75KZS/7fOLm6l justin@eunomia"
              ];
            };
          })
        ];
      };
      inherit (sys.config.system) build;
    in {
      enable = true;
      openFirewall = true;
      dhcpNoBind = true;

      mode = "boot";
      kernel = "${build.kernel}/bzImage";
      initrd = "${build.netbootRamdisk}/initrd";
      cmdLine = "init=${build.toplevel}/init loglevel=4";
      debug = true;
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
      hyprland = {
        enable = true;
      };
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

    services = {
      navidrome.enable = false;
      paperless.enable = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    groups.mediahost = {};
    users = {
      justin = {
        isNormalUser = true;
        description = "Justin";
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "input"
          "systemd-journal"
          "dialout"
          "stowage"
        ];
        shell = pkgs.fish;
      };
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
    firewall.allowedTCPPorts = [
      8000
      21040 # sftpgo-ftp
      27016
      8123 # home-assistant
    ];
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

  # networking.firewall.allowedTCPPorts = [ 27016 ];
  networking.firewall.allowedUDPPorts = [27016];
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
    fish = {
      enable = true;
      interactiveShellInit = ''
        set -U fish_greeting
        set -gx EDITOR nvim
        set -gx VISUAL nvim
        fish_vi_key_bindings

        set -l foreground c0caf5
        set -l selection 283457
        set -l comment 565f89
        set -l red f7768e
        set -l orange ff9e64
        set -l yellow e0af68
        set -l green 9ece6a
        set -l purple 9d7cd8
        set -l cyan 7dcfff
        set -l pink bb9af7

        set -g fish_color_normal $foreground
        set -g fish_color_command $cyan
        set -g fish_color_keyword $pink
        set -g fish_color_quote $yellow
        set -g fish_color_redirection $foreground
        set -g fish_color_end $orange
        set -g fish_color_option $pink
        set -g fish_color_error $red
        set -g fish_color_param $purple
        set -g fish_color_comment $comment
        set -g fish_color_selection --background=$selection
        set -g fish_color_search_match --background=$selection
        set -g fish_color_operator $green
        set -g fish_color_escape $pink
        set -g fish_color_autosuggestion $comment

        set -g fish_pager_color_progress $comment
        set -g fish_pager_color_prefix $cyan
        set -g fish_pager_color_completion $foreground
        set -g fish_pager_color_description $comment
        set -g fish_pager_color_selected_background --background=$selection

        starship init fish | source
      '';

      shellAbbrs.vi = "nvim";
    };
    gamescope.enable = true;
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[󰇸](bold red)";
          vicmd_symbol = "[❯](bold green)";
        };
        directory = {
          truncate_to_repo = false;
        };
        aws = {
          disabled = true;
          symbol = "  ";
        };
        buf.symbol = " ";
        c.symbol = " ";
        directory.read_only = " ";
        docker_context.symbol = " ";
        git_branch.symbol = " ";
        haskell.symbol = " ";
        java.symbol = " ";
        julia.symbol = " ";
        memory_usage.symbol = " ";
        nix_shell.symbol = " ";
        nodejs.symbol = " ";
        package.symbol = " ";
        python.symbol = " ";
        rust.symbol = " ";
        terraform.symbol = " ";
      };
    };
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
  security.pam.services = {
    swaylock.text = "auth include login";
    hyprlock.text = "auth include login";
  };

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  security.wrappers = {
    "9fs" = {
      owner = "root";
      group = "root";
      permissions = "u+rx,g+x,o+x";
      setuid = true;
      source = "${inputs'.stowage.packages.mount}/bin/stowage-cmd-mount";
    };
  };

  users.groups.stowage = {};
  users.users.stowage = {
    isSystemUser = true;
    group = "stowage";
    extraGroups = [];
    packages = [];
    shell = pkgs.fish;
  };
}
