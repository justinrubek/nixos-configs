{self, ...} @ inputs: {pkgs, ...}: {
  nix = {
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
  };
  homebrew = {
    enable = true;
    casks = ["firefox" "visual-studio-code" "wezterm"];
  };
  security.pam.enableSudoTouchIdAuth = true;
  services.nix-daemon.enable = true;
  system = {
    configurationRevision = self.rev or "dirty";
    stateVersion = 5;
  };
  users.users.justin = {
    name = "justin";
    home = "/Users/justin";
  };
}
