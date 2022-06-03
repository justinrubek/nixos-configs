{ pkgs, username, ... }: 
let
  nvim = import ./config/nvim;

  shellAliases = {
      vi = "nvim";
      cat = "bat";
  };

  shellVariables = {
      EDITOR = "vi";
  };
in {
    home.username = "justin";
    home.homeDirectory = "/home/justin";
	home.packages = with pkgs; [ 
		htop yarn poetry awscli python39Packages.pip
		gnumake 
		ripgrep lsd fd jq bottom gtop gping procs httpie curlie zoxide 
	];
    xdg.enable = true;


	programs.neovim = nvim pkgs;

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

    programs.bat.enable = true;
    programs.fzf.enable = true;
}
