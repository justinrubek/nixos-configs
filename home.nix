{ pkgs, ... }: {
        home.username = "justin";
	home.homeDirectory = "/home/justin";
	home.packages = with pkgs; [ 
		htop yarn poetry awscli python39Packages.pip
		gnumake 
		ripgrep lsd bat fd jq bottom gtop gping procs httpie curlie zoxide 
	];


	programs.neovim = {
		enable = true;
	};

	programs.git = {
		enable = true;
		userName = "Justin Rubek";
		userEmail = "justin@koloni.me";
	};

	programs.bash = {
		enable = true;
		shellAliases = {
			vi = "nvim";
		};
	};

	programs.tmux = {
		enable = true;
		clock24 = true;
		extraConfig = ''
			set -g mouse on
		'';
	};
}
