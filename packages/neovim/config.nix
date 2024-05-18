{
  pkgs,
  inputs',
  ...
}: {
  imports = [
    ./which-key.nix
  ];

  clipboard = {
    register = "unnamedplus";
    providers = {
      wl-copy.enable = true;
      xclip.enable = true;
    };
  };

  colorschemes.tokyonight.enable = true;
  # colorschemes.nord.enable = true;

  globals = {
    mapleader = " ";
  };

  opts = {
    autoindent = true;
    autoread = true;
    compatible = false;
    cursorline = true;
    expandtab = true;
    hidden = true;
    ignorecase = true;
    incsearch = true;
    mouse = "a";
    number = true;
    relativenumber = true;
    scrolloff = 12;
    shiftwidth = 4;
    smartcase = true;
    smartindent = true;
    tabstop = 4;
    title = true;
    ttimeoutlen = 5;
    undofile = true;
  };

  plugins = {
    bufferline = {
      enable = true;
      diagnostics = "nvim_lsp";
      separatorStyle = "slant";
    };
    cmp = {
      enable = true;
      settings = {
        mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        };
        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        sources = [
          {name = "nvim_lsp";}
          {
            name = "nvim_lsp";
            keywordLength = 3;
          }
          {
            name = "luasnip";
            keywordLength = 2;
          }
          {
            name = "treesitter";
            keywordLength = 2;
          }
          {name = "path";}
          {
            name = "buffer";
            keywordLength = 3;
          }
        ];
        window = {
          completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None";
            colOffset = -4;
            sidePadding = 0;
            border = "single";
          };
          documentation = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None";
            border = "single";
          };
        };
      };
    };
    cmp-nvim-lsp.enable = true;
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    cmp-vsnip.enable = true;
    cmp-cmdline.enable = true;
    comment.enable = true;
    # copilot-lua.enable = true;
    copilot-vim.enable = true;
    # cmp-copilot.enable = true;
    cursorline = {
      enable = true;
      cursorline.enable = false;
      cursorword.enable = true;
    };
    efmls-configs.enable = true;
    friendly-snippets.enable = true;
    fugitive.enable = true;
    indent-blankline = {
      enable = true;
      settings = {
        indent.char = "¦";
      };
    };
    intellitab.enable = true;
    nix.enable = true;
    nvim-tree.enable = true;
    lastplace.enable = true;
    lspkind = {
      enable = true;
      mode = "symbol_text";
      cmp = {
        ellipsisChar = "…";
        menu = {
          buffer = "[Buffer]";
          nvim_lsp = "[LSP]";
          luasnip = "[LuaSnip]";
          nvim_lua = "[Lua]";
          latex_symbols = "[Latex]";
          path = "[Path]";
          treesitter = "[Treesitter]";
        };
        after = ''
          function(entry, vim_item, kind)
              -- local strings = vim.split(kind.kind, "%s", { trimempty = true })
              -- kind.kind = " " .. strings[1] .. " "
              -- kind.menu = "   " .. strings[2]

              return kind
          end
        '';
      };
    };
    lsp = {
      enable = true;
      servers = {
        astro.enable = true;
        cssls.enable = true;
        html.enable = true;
        jsonls.enable = true;
        lua-ls.enable = true;
        nil_ls.enable = true;
        pyright.enable = true;
        rust-analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
        tailwindcss.enable = true;
        terraformls.enable = true;
        texlab.enable = true;
        tsserver.enable = true;
      };

      # onAttach = ''
      #   vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
      # '';
    };
    lsp-lines = {
      enable = true;
      currentLine = true;
    };
    lspsaga.enable = true;
    lualine.enable = true;
    luasnip.enable = true;
    none-ls = {
      enable = true;
      sources = {
        formatting = {
          alejandra.enable = true;
        };
      };
    };
    surround.enable = true;
    telescope.enable = true;
    todo-comments.enable = true;
    treesitter = {
      enable = true;
      moduleConfig = {
        highlight = {
          enable = true;
        };
      };
    };
    trouble.enable = true;
    ts-autotag.enable = true;
    undotree.enable = true;
  };

  extraConfigLua = pkgs.lib.mkBefore ''
    ${builtins.readFile ./lua/functions.lua}
  '';

  extraConfigVim = ''
    luafile ${./lua/copilot.lua}
    luafile ${./lua/keymaps.lua}
  '';

  extraPlugins = with pkgs.vimPlugins; [
    vim-abolish
  ];

  extraPackages = [
    pkgs.nodejs
    pkgs.python310
    inputs'.ghlink.packages.ghlink
  ];
}
