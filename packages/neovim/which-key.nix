{
  helpers,
  pkgs,
  ...
}: let
  mkRequireBind = {
    module,
    cmd,
  }: helpers.mkRaw "function() require(\"${module}\").${cmd}() end";
  mkCmdBind = {cmd}: "<cmd>${cmd}<cr>";

  binds = {
    lsp = {
      code_action = mkCmdBind {
        cmd = "Lspsaga code_action";
      };
      definition = mkCmdBind {
        cmd = "lua vim.lsp.buf.definition()";
      };
      finder = mkCmdBind {
        cmd = "Lspsaga finder";
      };
      format = mkCmdBind {
        cmd = "lua vim.lsp.buf.format()";
      };
      hover = mkCmdBind {
        cmd = "lua vim.lsp.buf.hover()";
      };
      references = mkCmdBind {
        cmd = "lua vim.lsp.buf.references()";
      };
      rename = mkCmdBind {
        cmd = "Lspsaga rename";
      };
    };
    misc = {
      link_line = helpers.mkRaw "ghlink_lines";
      link_search = helpers.mkRaw "ghlink_search";
      toggle_tree = mkCmdBind {
        cmd = "NvimTreeToggle";
      };
      toggle_trouble = mkCmdBind {
        cmd = "TroubleToggle";
      };
      yank_without_indent = helpers.mkRaw "visual_yank_without_indent";
    };
    search = {
      buffers = mkCmdBind {
        cmd = "Telescope buffers";
      };
      changed_files = mkCmdBind {
        cmd = "Telescope git_status";
      };
      file_contents = mkRequireBind {
        module = "telescope.builtin";
        cmd = "live_grep";
      };
      file_names = mkRequireBind {
        module = "telescope.builtin";
        cmd = "find_files";
      };
      git_branch = mkCmdBind {
        cmd = "Telescope git_branches";
      };
      git_buffer_commits = mkRequireBind {
        module = "telescope.builtin";
        cmd = "git_bcommits_range";
      };
      git_commits = mkCmdBind {
        cmd = "Telescope git_bcommits";
      };
      opened_files = mkRequireBind {
        module = "telescope.builtin";
        cmd = "oldfiles";
      };
      lsp_definitions = mkRequireBind {
        module = "telescope.builtin";
        cmd = "lsp_definitions";
      };
      lsp_implementations = mkRequireBind {
        module = "telescope.builtin";
        cmd = "lsp_implementations";
      };
      lsp_references = mkRequireBind {
        module = "telescope.builtin";
        cmd = "lsp_references";
      };
      lsp_type_definitions = mkRequireBind {
        module = "telescope.builtin";
        cmd = "lsp_type_definitions";
      };
      treesitter = mkRequireBind {
        module = "telescope.builtin";
        cmd = "treesitter";
      };
    };
  };

  bindings = {
    normal = rec {
      opts = {
        buffer = helpers.mkRaw "nil";
        mode = "n";
        noremap = true;
        nowait = true;
        silent = true;
      };
      spec = [
        {
          __unkeyed-1 = "<leader>f";
          group = "find";
        }
        {
          __unkeyed-1 = "<leader>fl";
          group = "lsp";
        }
        {
          __unkeyed-1 = "<leader>b";
          group = "buffers";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "git";
        }
        {
          __unkeyed-1 = "<leader>l";
          group = "lsp";
        }
        {
          __unkeyed-1 = "<leader>t";
          group = "toggles";
        }
        {
          __unkeyed-1 = "<leader>c";
          group = "code";
        }
        {
          __unkeyed-1 = "<leader>ff";
          __unkeyed-2 = binds.search.file_names;
          desc = "find file";
        }
        {
          __unkeyed-1 = "<leader>fo";
          __unkeyed-2 = binds.search.opened_files;
          desc = "open recent file";
        }
        {
          __unkeyed-1 = "<leader>fs";
          __unkeyed-2 = binds.search.file_contents;
          desc = "search";
        }
        {
          __unkeyed-1 = "<leader>ft";
          __unkeyed-2 = binds.search.treesitter;
          desc = "treesitter";
        }
        {
          __unkeyed-1 = "<leader>fld";
          __unkeyed-2 = binds.search.lsp_definitions;
          desc = "definitions";
        }
        {
          __unkeyed-1 = "<leader>fli";
          __unkeyed-2 = binds.search.lsp_implementations;
          desc = "implementations";
        }
        {
          __unkeyed-1 = "<leader>flr";
          __unkeyed-2 = binds.search.lsp_references;
          desc = "references";
        }
        {
          __unkeyed-1 = "<leader>flt";
          __unkeyed-2 = binds.search.lsp_type_definitions;
          desc = "type definitions";
        }
        {
          __unkeyed-1 = "<leader>bf";
          __unkeyed-2 = binds.search.buffers;
          desc = "find";
        }
        {
          __unkeyed-1 = "<leader>go";
          __unkeyed-2 = binds.search.changed_files;
          desc = "find changed files";
        }
        {
          __unkeyed-1 = "<leader>gb";
          __unkeyed-2 = binds.search.git_branch;
          desc = "checkout branch";
        }
        {
          __unkeyed-1 = "<leader>gc";
          __unkeyed-2 = binds.search.git_commits;
          desc = "checkout commits";
        }
        {
          __unkeyed-1 = "<leader>la";
          __unkeyed-2 = binds.lsp.code_action;
          desc = "code action";
        }
        {
          __unkeyed-1 = "<leader>ld";
          __unkeyed-2 = binds.lsp.definition;
          desc = "definition";
        }
        {
          __unkeyed-1 = "<leader>lf";
          __unkeyed-2 = binds.lsp.format;
          desc = "format";
        }
        {
          __unkeyed-1 = "<leader>lh";
          __unkeyed-2 = binds.lsp.hover;
          desc = "hover";
        }
        {
          __unkeyed-1 = "<leader>lr";
          __unkeyed-2 = binds.lsp.rename;
          desc = "rename";
        }
        {
          __unkeyed-1 = "<leader>lu";
          __unkeyed-2 = binds.lsp.references;
          desc = "references";
        }
        {
          __unkeyed-1 = "<leader>tt";
          __unkeyed-2 = binds.misc.toggle_tree;
          desc = "file tree";
        }
        {
          __unkeyed-1 = "<leader>te";
          __unkeyed-2 = binds.misc.toggle_trouble;
          desc = "trouble";
        }
        {
          __unkeyed-1 = "<leader>cf";
          __unkeyed-2 = binds.lsp.finder;
          desc = "lsp finder";
        }
      ];
    };
    visual = rec {
      opts = {
        mode = "v";
        buffer = helpers.mkRaw "nil";
        silent = true;
        noremap = true;
        nowait = true;
      };
      spec = [
        {
          __unkeyed-1 = "<leader>g";
          group = "git";
        }
        {
          __unkeyed-1 = "<leader>y";
          group = "yank";
        }
        {
          __unkeyed-1 = "<leader>l";
          group = "link-to";
        }
        {
          __unkeyed-1 = "<leader>gb";
          __unkeyed-2 = binds.search.git_buffer_commits;
          desc = "buffer commits in selection";
        }
        {
          __unkeyed-1 = "<leader>yy";
          __unkeyed-2 = binds.misc.yank_without_indent;
          desc = "yank without indent";
        }
        {
          __unkeyed-1 = "<leader>ll";
          __unkeyed-2 = binds.misc.link_line;
          desc = "link using line numbers";
        }
        {
          __unkeyed-1 = "<leader>ls";
          __unkeyed-2 = binds.misc.link_search;
          desc = "link using search";
        }
      ];
    };
  };
in {
  extraConfigLua = let
    names = builtins.attrNames bindings;
    generateRegistrations = name: let
      inherit (bindings.${name}) spec opts;
      finalSpec = (helpers.listToUnkeyedAttrs spec) // opts;
    in "require(\"which-key\").add(${helpers.toLuaObject finalSpec})";
  in
    builtins.concatStringsSep "\n" (builtins.map generateRegistrations names);

  extraPlugins = [pkgs.vimPlugins.which-key-nvim];
}
