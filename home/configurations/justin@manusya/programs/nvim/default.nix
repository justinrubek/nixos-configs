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

  github-copilot = pkgs.vimUtils.buildVimPlugin {
    name = "copilot-vim";
    src = pkgs.fetchFromGitHub {
      owner = "github";
      repo = "copilot.vim";
      rev = "c2e75a3";
      sha256 = "sha256-V13La54aIb3hQNDE7BmOIIZWy7In5cG6kE0fti/wxVQ=";
    };
  };

  nvim-dap-python = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-dap-python";
    src = pkgs.fetchFromGitHub {
      owner = "mfussenegger";
      repo = "nvim-dap-python";
      rev = "2911f31";
      sha256 = "sha256-7xkzbaTs7QPTGuTGWstVqR4B/29Uvl0JMY4W+uX38go=";
    };
  };

  python_debug = pkgs.python39.withPackages (pypkgs: with pypkgs; [debugpy]);
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
        luafile ${PWD}/lua/colorscheme.lua
      ]]
      end, 70)


    local dap_python = require("dap-python")
    dap_python.setup("${python_debug}/bin/python")
    dap_python.test_runner = "pytest"
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

    # debugging
    nvim-dap
    nvim-dap-python

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

    github-copilot

    # theme
    sonokai
  ];

  extraPackages = with pkgs; [python39Packages.debugpy];
}
