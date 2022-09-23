{self, ...}: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.base;

  shellAliases = {
    vi = "nvim";
    cat = "bat";
  };

  shellVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    SHELL = "${pkgs.zsh}/bin/zsh";
  };
in {
  options.profiles.base = {
    enable = lib.mkEnableOption "base profile";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = shellVariables;
    systemd.user.sessionVariables = shellVariables;

    xdg.enable = true;

    programs = {
      univim.enable = true;

      bat.enable = true;
      lsd = {
        enable = true;
        enableAliases = true;
      };
      htop.enable = true;
      bottom.enable = true;
      jq.enable = true;

      readline = {
        enable = true;
        extraConfig = ''
          set editing-mode vi
        '';
      };

      bash = {
        enable = true;
        inherit shellAliases;
      };

      zsh = {
        enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;
        enableVteIntegration = true;
        autocd = true;
        defaultKeymap = "viins";
        history.extended = true;
        sessionVariables = shellVariables;
        inherit shellAliases;
        plugins = [
          {
            name = "zsh-autosuggestions";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-autosuggestions";
              rev = "v0.6.0";
              sha256 = "1h8h2mz9wpjpymgl2p7pc146c1jgb3dggpvzwm9ln3in336wl95c";
            };
          }
          {
            name = "fast-syntax-highlighting";
            src = pkgs.fetchFromGitHub {
              owner = "zdharma";
              repo = "fast-syntax-highlighting";
              rev = "817916dfa907d179f0d46d8de355e883cf67bd97";
              sha256 = "0m102makrfz1ibxq8rx77nngjyhdqrm8hsrr9342zzhq1nf4wxxc";
            };
          }
        ];
      };

      starship = {
        enable = true;
        enableBashIntegration = true;
        settings = {
          add_newline = true;
          character = {
            success_symbol = "[➜](bold green)";
            error_symbol = "[](bold red)";
            vicmd_symbol = "[❯](bold green)";
          };
          directory = {
            truncate_to_repo = false;
          };
          aws = {
            disabled = true;
            symbol = "  ";
          };
          buf.symbol = " ";
          c.symbol = " ";
          directory.read_only = " ";
          docker_context.symbol = " ";
          git_branch.symbol = " ";
          haskell.symbol = " ";
          java.symbol = " ";
          julia.symbol = " ";
          memory_usage.symbol = " ";
          nix_shell.symbol = " ";
          nodejs.symbol = " ";
          package.symbol = " ";
          python.symbol = " ";
          rust.symbol = " ";
          terraform.symbol = " ";
        };
      };

      direnv = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      tmux = {
        enable = true;
        clock24 = true;
        extraConfig = ''
          set -g mouse on
        '';
      };

      zoxide = {
        enable = true;
        enableBashIntegration = true;
      };

      fzf.enable = true;
    };

    home.packages = with pkgs; [
      psmisc
      fd
      zip
      unzip
      neofetch
      procs
      duf
      obs-studio
      bitwarden
    ];
  };
}
