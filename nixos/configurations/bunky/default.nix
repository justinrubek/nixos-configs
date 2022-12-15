{unixpkgs, ...} @ inputs: {
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
  ];

  # Linux kernel

  # Enable networking
  # networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  # personal modules
  justinrubek = {
    nomad.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    justin = {
      isNormalUser = true;
      description = "Justin";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;

      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsUQZGQOH2kmQNeG/Ezmsv6A/70JUO8nLh9WaZ/o7DlmpYeEyUdloTazxpP9FjuRv7d7nzRqtQFOF74TBaDEAxR9/eHxX9zc5RfyE1RYeGWPGgnuHpxoTijh70ncTlU6sr0oqP7e24qeIy7pqWKQmV8RDOkr2etbnb5OpCHEsZJ0l0sPYQpYi0Ud8cM/HFCCVPeg21wVuxBX2rA4ze8+YgnPJZRnhtHZg7rAapvhiIfDAJ3xIweauCoz0vZdmANlUsg2AoOx9b2Ym6rGNmRrJUNZYcsNxmUHc1/oc1g9NZ7GoaMhfw0BHVJ0kyfE2glpJX9iu6WHWjbL+XM0QnCFrc3hbQc41zYQsMHcY/N/P5MW9Gj77Q9P/qRDbwlVOdoFw1bUpIoMgsJ95o5gv5mClHuBLZD3ZO5cyRfnjH4w0pt6EnWtbkORsT5A7ULOQOG8AOuBL3ok/yVTVAFV2yMbaEg1BM2By0U6hn9M6SGWuOiM1oMwvVFJWdmZsvPeTZqaU= justin"
      ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  # services.openssh = {
  #   enable = true;
  #   permitRootLogin = "no";
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
}
