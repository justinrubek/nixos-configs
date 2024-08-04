{
  nixpkgs,
  nixos-hardware,
  ...
} @ inputs: {
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./bootloader.nix
    ./hardware.nix
    nixos-hardware.nixosModules.microsoft-surface-common
  ];
  system.stateVersion = "24.05";

  microsoft-surface = {
    kernelVersion = "6.8";
    ipts = {
      enable = true;
      config = {
        Config = {
          BlockOnPalm = true;
          TouchThreshold = 20;
          StabilityThreshold = 0.1;
        };
        Contacts = {
          SizeMin = 0.818;
          SizeMax = 3.987;
          AspectMin = 1.009;
          AspectMax = 3.630;
        };
      };
    };
  };

  time.timeZone = "America/Chicago";
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  programs.zsh.enable = true;

  services = {
    displayManager.sddm.enable = true;
    xserver.enable = true;
    openssh.enable = true;
  };
  justinrubek = {
    windowing.plasma.enable = true;
    windowing.hyprland.enable = true;

    graphical.fonts.enable = true;

    tailscale.enable = true;
  };

  networking.firewall.allowedTCPPorts = [22];

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users = {
    justin = {
      isNormalUser = true;
      description = "Justin";
      extraGroups = ["networkmanager" "wheel" "docker" "input" "systemd-journal"];
      shell = pkgs.zsh;
    };
  };

  networking = {
    networkmanager = {
      enable = true;
    };
  };
}
