{
  config,
  pkgs,
  inputs,
  inputs',
  lib,
  ...
}: {
  imports = [./hardware.nix];

  boot = {
    supportedFilesystems = ["ext4"];
  };

  time.timeZone = "America/Chicago";

  services = {
    displayManager = {
      defaultSession = "hyprland";
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

  justinrubek = {
    graphical.fonts.enable = true;
    sound.enable = true;
    tailscale.enable = true;
    windowing = {
      hyprland = {
        enable = true;
      };
    };
  };

  users = {
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

  environment.systemPackages = [
    pkgs.tailscale
  ];

  networking = {
    networkmanager = {
      enable = true;
      wifi.scanRandMacAddress = false;
    };
  };
  systemd = {
    services = {
      mediahost-nas-mount = let
        target = "tcp!nas!4501";
        homeDir = "/home/mediahost";
        mnt = "${homeDir}/n/nas";
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
          User = "mediahost";
        };
      };
    };
  };

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

  # enable fix for steam issues with xdg-desktop-portal
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  # allow swaylock to verify login
  security.pam.services = {
    swaylock.text = "auth include login";
    hyprlock.text = "auth include login";
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
}
