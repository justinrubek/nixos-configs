{
  inputs,
  inputs',
  pkgs,
  ...
}: {
  imports = [
    ./bootloader.nix
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.microsoft-surface-common
  ];
  system.stateVersion = "24.05";

  microsoft-surface = {
    kernelVersion = "6.11.4";
  };

  time.timeZone = "America/Chicago";
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  programs.zsh.enable = true;

  services = {
    displayManager.sddm.enable = true;
    iptsd = {
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
    xserver.enable = true;
    openssh.enable = true;
  };
  systemd.services = {
    cam2ip = {
      description = "webcam IP camera";
      requires = ["network.target"];
      serviceConfig = {
        ExecStart = "${inputs'.cam2ip.packages.cam2ip}/bin/cam2ip --width 1280 --height 720";
        Nice = -10;
        IOSchedulingClass = 2;
      };
    };
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
