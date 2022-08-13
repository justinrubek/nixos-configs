{
  unixpkgs,
  self,
  ...
} @ inputs: pkgs: let
  nvim-lsp-installer = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-lsp-installer";
    src = pkgs.fetchFromGitHub {
      owner = "justinrubek";
      repo = "nvim-lsp-installer";
      rev = "4d35f4c";
      sha256 = "sha256-GMrNOCVcd0cM0jNaeuJhGQumuFaNeZT9Z7+5K5/y7jo=";
    };
  };
  cmp-copilot = pkgs.vimUtils.buildVimPlugin {
    name = "cmp-copilot";
    src = pkgs.fetchFromGitHub {
      owner = "hrsh7th";
      repo = "cmp-copilot";
      rev = "1f3f31c";
      sha256 = "sha256-2j3Y2vvBHXLD+fPH7fbvjKadd6X/uuHI0ajkjTJR35I=";
    };
  };

  github-copilot = pkgs.vimUtils.buildVimPlugin {
    name = "copilot-vim";
    src = pkgs.fetchFromGitHub {
      owner = "github";
      repo = "copilot.vim";
      rev = "c2e75a3";
      sha256 = "sha256-V13La54aIb3hQNDE7BmOIIZWy7In5cG6kE0fti/wxVQ=";
    };
  };

  PWD = ./.;
in {
  enable = true;
  colorschemes.tokyonight.enable = true;

  globals = {
    mapleader = " ";
  };

  options = {
    cursorline = true;
    relativenumber = true;
    number = true;
    scrolloff = 12;

    smartcase = true;
    ttimeoutlen = 5;
    compatible = false;
    autoread = true;
    incsearch = true;
    hidden = true;

    smartindent = true;
    autoindent = true;
    tabstop = 4;
    shiftwidth = 4;
    expandtab = true;
  };

  plugins = {
    bufferline = {
      enable = true;
      diagnostics = "nvim_lsp";
    };
    telescope = {
      enable = true;
    };
    treesitter = {
      enable = true;
      ensureInstalled = "all";
    };
  };

  extraConfigVim = ''
    luafile ${PWD}/lua/lsp.lua
    lua << EOF
    vim.defer_fn(function()
      vim.cmd [[
        luafile ${PWD}/lua/copilot.lua
        luafile ${PWD}/lua/which-key.lua
        luafile ${PWD}/lua/keymaps.lua
      ]]
      end, 70)

    EOF
  '';

  extraPlugins = with pkgs.vimPlugins; [
    plenary-nvim
    indentLine

    # lsp
    friendly-snippets
    luasnip
    nvim-lsp-installer
    nvim-lspconfig
    lspkind-nvim
    cmp-copilot
    cmp-nvim-lsp
    cmp-buffer
    cmp-path
    cmp-vsnip
    cmp-cmdline
    nvim-cmp

    # File tree
    nvim-web-devicons
    nvim-tree-lua

    # Aesthetic
    todo-comments-nvim
    vim-cursorword
    vim-nix

    # tpope
    vim-abolish

    # folke
    which-key-nvim

    github-copilot
  ];

  extraPackages = with pkgs; [
    nodejs
    python310
  ];
}
