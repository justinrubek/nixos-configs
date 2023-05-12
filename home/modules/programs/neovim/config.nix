{
  pkgs,
  username,
  ...
} @ inputs: let
  # example quick source get for non-packaged plugins
  # nvim-lsp-installer = pkgs.vimUtils.buildVimPlugin {
  #   name = "nvim-lsp-installer";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "justinrubek";
  #     repo = "nvim-lsp-installer";
  #     rev = "4d35f4c";
  #     sha256 = "sha256-GMrNOCVcd0cM0jNaeuJhGQumuFaNeZT9Z7+5K5/y7jo=";
  #   };
  # };
  PWD = ./.;
in {
  enable = true;

  colorschemes.tokyonight.enable = true;
  # colorschemes.nord.enable = true;

  globals = {
    mapleader = " ";
  };

  options = {
    mouse = "a";
    shiftwidth = 4;
    tabstop = 4;
    smartindent = true;
    autoindent = true;
    expandtab = true;
    smartcase = true;
    ignorecase = true;

    number = true;
    relativenumber = true;
    cursorline = true;
    scrolloff = 12;

    ttimeoutlen = 5;
    compatible = false;
    autoread = true;
    incsearch = true;
    hidden = true;

    undodir = "/home/${username}/.cache/nvim/undodir";
    undofile = true;

    clipboard = "unnamedplus";
  };

  plugins = {
    bufferline = {
      enable = true;
      diagnostics = "nvim_lsp";
      separatorStyle = "slant";
    };
    telescope = {
      enable = true;
    };

    treesitter = {
      enable = true;
      ensureInstalled = "all";
      nixGrammars = true;
      moduleConfig = {
        autotag = {
          enable = true;
          filetypes = ["html" "xml" "astro" "javascriptreact" "typescriptreact" "svelte"];
        };
        highlight = {
          enable = true;
        };
      };
    };

    comment-nvim.enable = true;

    copilot = {
      enable = true;
    };
    cmp-copilot.enable = true;

    undotree = {
      enable = true;
    };

    nix.enable = true;
    intellitab.enable = true;
    nvim-tree.enable = true;
    surround.enable = true;

    lspkind = {
      enable = true;
      mode = "symbol_text";
      cmp.ellipsisChar = "…";
      cmp.menu = {
        buffer = "[Buffer]";
        nvim_lsp = "[LSP]";
        luasnip = "[LuaSnip]";
        nvim_lua = "[Lua]";
        latex_symbols = "[Latex]";
      };
      cmp.after = ''
        function(entry, vim_item, kind)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. strings[1] .. " "
            kind.menu = "   " .. strings[2]

            return kind
        end
      '';
    };
    lsp = {
      enable = true;
      servers = {
        astro.enable = true;
        cssls.enable = true;
        html.enable = true;
        jsonls.enable = true;
        nil_ls.enable = true;
        # rnix-lsp.enable = true;
        rust-analyzer.enable = true;
        pyright.enable = true;
        tailwindcss.enable = true;
        terraformls.enable = true;
        texlab.enable = true;
        tsserver.enable = true;
      };

      onAttach = ''
        vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
      '';
    };
    lsp-lines = {
      enable = true;
      currentLine = true;
    };
    lspsaga.enable = true;
    null-ls = {
      enable = true;
      sources = {
        formatting = {
          alejandra.enable = true;
        };

        diagnostics = {
          shellcheck.enable = true;
        };
      };
    };

    trouble.enable = true;

    nvim-cmp = {
      enable = true;
      sources = [{name = "nvim_lsp";}];
      mappingPresets = ["insert"];
      mapping = {
        "<CR>" = "cmp.mapping.confirm({ select = true })";
      };
      formatting.fields = ["kind" "abbr" "menu"];

      window.completion = {
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None";
        colOffset = -4;
        sidePadding = 0;
        border = "single";
      };

      window.documentation = {
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None";
        border = "single";
      };

      snippet.expand = "luasnip";
    };

    lualine = {
      enable = true;
    };

    lastplace.enable = true;

    fugitive.enable = true;
  };

  # luafile ${PWD}/lua/lsp.lua
  extraConfigVim = ''
    luafile ${PWD}/lua/copilot.lua
    luafile ${PWD}/lua/which-key.lua
    luafile ${PWD}/lua/keymaps.lua
  '';

  extraPlugins = with pkgs.vimPlugins; [
    plenary-nvim
    indentLine

    # lsp
    friendly-snippets
    luasnip
    # nvim-lsp-installer
    # nvim-lspconfig
    # lspkind-nvim
    cmp-nvim-lsp
    cmp-buffer
    cmp-path
    cmp-vsnip
    cmp-cmdline

    # File tree
    nvim-web-devicons
    nvim-tree-lua

    # Aesthetic
    todo-comments-nvim
    vim-cursorword

    # tpope
    vim-abolish

    # folke
    which-key-nvim
  ];

  extraPackages = [
    pkgs.nodejs-16_x
    pkgs.python310
  ];
}
