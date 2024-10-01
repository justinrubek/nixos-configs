inputs: {
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    networkmanager.enable = true;
    hosts = {
      "192.168.64.3" = ["server.kubernetes.local" "kube-server"];
      "192.168.64.4" = ["node-0.kubernetes.local" "kube-node-0"];
      "192.168.64.5" = ["node-1.kubernetes.local" "kube-node-1"];
    };
  };
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  security.sudo.wheelNeedsPassword = false;
  services = {
    openssh.enable = true;
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
  };

  users.users.justin = {
    isNormalUser = true;
    description = "Justin Rubek";
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = [
      pkgs.kdePackages.kate
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAWyGeNxOahO03gCLeiIF2Iz3QSTXPm2dzJJu7VnfEpZ justin@M-JWW1JWQ5PW"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    inputs.self.packages.${pkgs.system}.neovim
    pkgs.kubectl
    pkgs.kubernetes
    pkgs.cri-tools
    pkgs.runc
    pkgs.cni-plugins
    pkgs.containerd
    pkgs.etcd
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
