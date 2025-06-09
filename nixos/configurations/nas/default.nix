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
        fish_vi_key_bindings
        set -x EDITOR nvim
        set -x VISUAL nvim
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
      ListenStream = "4501"; # Your desired port
      Accept = "yes";
    };
  };

  systemd.services."u9fs@" = let
    mountDir = "/mnt/data/root";
    user = "stowage";
    package = pkgs.u9fs.overrideAttrs (old: {
      dontStrip = true;
      enableDebugging = true;
      NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + " -g -O0 -DDEBUG";
    });
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
