{comma, ...}: {pkgs, ...}: {
  config = {
    activeProfiles = ["development"];

    home.packages = with pkgs; [
      comma.packages.x86_64-linux.default
      alejandra
    ];

    programs.zellij = {
      enable = true;
      settings = {
        default-shell = "zsh";
      };
    };
  };
}
