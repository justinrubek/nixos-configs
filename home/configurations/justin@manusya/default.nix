{
  unixpkgs,
  nurpkgs,
  self,
  ...
} @ inputs: {
  pkgs,
  username,
  ...
}: let
  shellAliases = {
    vi = "nvim";
    cat = "bat";
  };

  shellVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
in {
  config = {
    home.sessionVariables = shellVariables;
    systemd.user.sessionVariables = shellVariables;
    xdg.enable = true;
    fonts.fontconfig.enable = true;

    # custom vim config
    programs.univim.enable = true;

    home.packages = with pkgs; [
      ripgrep
      fd
      gtop
      gping
      procs
      httpie
      curlie
      duf
      zip
      unzip
      psmisc
      tectonic
      speedcrunch
      flameshot
      bitwarden
      ffmpeg
      youtube-dl
      obs-studio
      vlc
      blender
      kdenlive
      protontricks
      rofi
      gnumake
      gcc
      cargo
      rust-analyzer
      discord
      brave
      nerdfonts
      bitwarden
      neofetch
      rustc
      slack
      lagrange
      gimp
      teamspeak_client
      openscad
      scrcpy
      zoom-us
      protontricks
    ];

    programs.firefox = import ./programs/firefox {inherit pkgs username;};

    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      userName = "Justin Rubek";
      userEmail = "25621857+justinrubek@users.noreply.github.com";
      delta.enable = true;
    };

    programs.starship = {
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

    programs.readline = {
      enable = true;
      extraConfig = ''
        set editing-mode vi
      '';
    };

    programs.bash = {
      enable = true;
      inherit shellAliases;
    };

    programs.zsh = {
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

    programs.tmux = {
      enable = true;
      clock24 = true;
      extraConfig = ''
        set -g mouse on
      '';
    };

    programs.broot = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    programs.bat.enable = true;
    programs.fzf.enable = true;
    programs.lsd = {
      enable = true;
      enableAliases = true;
    };
    programs.htop.enable = true;
    programs.bottom.enable = true;
    programs.jq.enable = true;
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
    };

    programs.mpv.enable = true;

    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    services.syncthing = {
      enable = true;
      tray.enable = true;
    };
    programs.pandoc.enable = true;

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
