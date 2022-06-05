{ pkgs, username, ... }: 
let
  shellAliases = {
      vi = "nvim";
      cat = "bat";
  };

  shellVariables = {
      EDITOR = "vi";
      VISUAL = "vi";
  };
in {
    home.username = "justin";
    home.homeDirectory = "/home/justin";
    home.sessionVariables = shellVariables;
    xdg.enable = true;

	home.packages = with pkgs; [ 
		git ripgrep fd gtop gping procs httpie curlie duf zip unzip
        tectonic
        speedcrunch flameshot bitwarden
        ffmpeg youtube-dl obs-studio vlc
        blender kdenlive
        protontricks
        rofi
        gnumake gcc
	];

	programs.neovim = import ./programs/nvim pkgs;
	programs.firefox = import ./programs/firefox { inherit pkgs username; };

	programs.git = {
		enable = true;
		userName = "Justin Rubek";
		userEmail = "justin@koloni.me";
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

}
