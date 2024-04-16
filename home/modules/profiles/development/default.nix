{ self, ... }@inputs:
{
  config,
  lib,
  pkgs,
  specialArgs,
  ...
}:
let
  cfg = config.profiles.development;
in
{
  options.profiles.development = {
    enable = lib.mkEnableOption "development profile";
  };

  config =
    let
      full_name = "Justin Rubek";
      email = "25621857+justinrubek@users.noreply.github.com";
      name = specialArgs.username;
    in
    lib.mkIf cfg.enable {
      programs = {
        git = {
          enable = true;
          package = pkgs.gitFull;

          userName = full_name;
          userEmail = email;

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

          lfs.enable = true;
        };

        broot = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
        };
      };

      justinrubek.programs.pijul = {
        enable = true;
        config = {
          inherit full_name name email;
        };
      };

      home.packages = with pkgs; [
        ripgrep
        httpie
        curlie
        gnumake
        gcc
        inputs.git-prune-branches.packages.${pkgs.system}.git-prune-branches
        inputs.gitu.packages.${pkgs.system}.gitu
        cargo
        rustc
        rust-analyzer
        # openscad
        deadnix
        statix
        cocogitto

        dig

        pkgs.nix-output-monitor
      ];
    };
}
