{pkgs, ...}: let
  PWD = builtins.toString ./.;
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
in {
  enable = true;
  vimAlias = true;

  withNodeJs = true;
  withPython3 = true;

  extraConfig = ''
    luafile ${PWD}/lua/lsp.lua
    lua << EOF
    vim.defer_fn(function()
      vim.cmd [[
        luafile ${PWD}/settings.lua
        luafile ${PWD}/lua/copilot.lua
        luafile ${PWD}/lua/treesitter.lua
        luafile ${PWD}/lua/bufferline.lua
        luafile ${PWD}/lua/which-key.lua
        luafile ${PWD}/lua/keymaps.lua
      ]]
      end, 70)
    EOF
  '';

  plugins = with pkgs.vimPlugins; [
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

    # navigation
    telescope-nvim
    bufferline-nvim

    # File tree
    nvim-web-devicons
    nvim-tree-lua

    # Aesthetic
    nvim-treesitter
    todo-comments-nvim
    vim-cursorword

    # tpope
    vim-abolish

    # folke
    which-key-nvim

    copilot-vim
  ];
}
