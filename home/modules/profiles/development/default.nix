{self, ...}: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.development;
in {
  options.profiles.development = {
    enable = lib.mkEnableOption "development profile";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        package = pkgs.gitFull;

        userName = "Justin Rubek";
        userEmail = "25621857+justinrubek@users.noreply.github.com";

        delta.enable = true;

        extraConfig = {
          init.defaultBranch = "main";
          pull.rebase = false;
          push.autoSetupRemote = true;
        };

        aliases = {
          sw = "switch";
          co = "checkout";
          ci = "commit";
          st = "status";
          br = "branch";
          ps = "push";
          pl = "pull";
          graph = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold cyan)%h%C(reset) - %C(green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all";
        };
      };

      broot = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
    };

    home.packages = with pkgs; [
      ripgrep
      httpie
      curlie
      gnumake
      gcc
      cargo
      rustc
      rust-analyzer
      openscad
      statix
      cocogitto
    ];
  };
}
