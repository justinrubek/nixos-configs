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
    stowage = {
      isSystemUser = true;
      group = "stowage";
    };
  };
  users.groups.stowage = {};

  environment.systemPackages = [
    inputs'.disko.packages.default
    pkgs.tailscale
    # self'.packages.neovim
    (
      pkgs.u9fs.overrideAttrs (old: {
        dontStrip = true;
        enableDebugging = true;
        NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + " -g -O0 -DDEBUG";
      })
    )
  ];

  networking = {
    networkmanager = {
      enable = true;
      wifi.scanRandMacAddress = false;
    };
    firewall.allowedTCPPorts = [
      4500 # 9p file server
      4501 # 9p alt file server
    ];
    # firewall.interfaces.${config.services.tailscale.interfaceName} = {
    #   allowedTCPPorts = [];
    # };
  };

  system.stateVersion = "22.11";

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
    zsh.enable = true;
  };
  security.sudo.wheelNeedsPassword = false;

  systemd.sockets.u9fs = {
    description = "9P filesystem server socket";
    wantedBy = ["sockets.target"];
    socketConfig = {
      ListenStream = "4501";
      Accept = "yes";
    };
  };

  systemd.services."u9fs@" = let
    mountDir = "/mnt/data/root";
    user = "stowage";
    package = inputs'.u9fs.packages.default;
  in {
    description = "9P filesystem server";
    after = ["network.target"];

    serviceConfig = {
      ExecStart = "${package}/bin/u9fs -D -a none -u ${user} -d ${mountDir}";
      User = "${user}";
      StandardInput = "socket";
      StandardError = "journal";
    };
  };

  # systemd.services.stowage = {
  #   description = "file server";

  #   wantedBy = ["multi-user.target"];
  #   wants = ["network-online.target"];
  #   after = ["network-online.target" "mnt-data.mount"];

  #   script = ''
  #     ${inputs'.stowage.packages.cli}/bin/stowage-cli server --addr '0.0.0.0:4500' --path /mnt/data/alt start
  #   '';

  #   serviceConfig = {
  #     User = "stowage";
  #     Group = "stowage";

  #     Type = "simple";
  #     Restart = "on-failure";
  #   };
  # };
}
