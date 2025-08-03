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

  boot = {
    supportedFilesystems = ["ext4"];
  };
  environment.systemPackages = [
    pkgs.firefox
    pkgs.tailscale
    pkgs.starship
  ];
  justinrubek = {
    graphical.fonts.enable = false;
    sound.enable = true;
    tailscale.enable = true;
    windowing = {
      plasma.enable = true;
    };
  };
  networking = {
    firewall.interfaces.${config.services.tailscale.interfaceName} = {
      allowedTCPPorts = [
        22
      ];
    };
    networkmanager = {
      enable = true;
      wifi.scanRandMacAddress = false;
    };
  };
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
    zsh.enable = true;
  };
  security.wrappers = {
    "9fs" = {
      owner = "root";
      group = "root";
      permissions = "u+rx,g+x,o+x";
      setuid = true;
      source = "${inputs'.stowage.packages.mount}/bin/stowage-cmd-mount";
    };
  };
  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };
    xserver.enable = true;
  };
  system.stateVersion = "25.11";
  systemd = {
    services = {
      mediahost-nas-mount = let
        homeDir = "/home/${user}";
        mnt = "${homeDir}/n/nas";
        target = "tcp!nas!4500";
        user = "justin";
      in {
        after = ["network.target"];
        description = "mount nas for media host";
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          ExecStart = [
            "/run/wrappers/bin/9fs mount -i '${target}' '${mnt}'"
            "/run/wrappers/bin/9fs bind '${mnt}/movies' '${homeDir}/movies'"
            "/run/wrappers/bin/9fs bind '${mnt}/music' '${homeDir}/music'"
            "/run/wrappers/bin/9fs bind '${mnt}/shows' '${homeDir}/shows'"
          ];
          ExecStartPre = [
            "${pkgs.coreutils}/bin/mkdir -p '${mnt}'"
            "${pkgs.coreutils}/bin/mkdir -p '${homeDir}/movies'"
            "${pkgs.coreutils}/bin/mkdir -p '${homeDir}/music'"
            "${pkgs.coreutils}/bin/mkdir -p '${homeDir}/shows'"
          ];
          ExecStop = [
            "/run/wrappers/bin/9fs umount '${mnt}/n/nas'"
            "/run/wrappers/bin/9fs umount '${homeDir}/movies'"
            "/run/wrappers/bin/9fs umount '${homeDir}/music'"
            "/run/wrappers/bin/9fs umount '${homeDir}/shows'"
          ];
          RemainAfterExit = true;
          Type = "oneshot";
          User = user;
        };
      };
    };
  };
  time.timeZone = "America/Chicago";
  users = {
    users = {
      justin = {
        description = "Justin";
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "input"
          "systemd-journal"
          "dialout"
        ];
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL1Uj62/yt8juK3rSfrVuX/Ut+xzw1Z75KZS/7fOLm6l"
        ];
        shell = pkgs.fish;
      };
    };
  };
}
