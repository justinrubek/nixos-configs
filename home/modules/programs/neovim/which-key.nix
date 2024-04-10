{
  helpers,
  pkgs,
  ...
}: let
  mkRequireBind = {
    module,
    cmd,
    desc,
  }: [
    (helpers.mkRaw "require(\"${module}\").${cmd}")
    desc
  ];
  mkCmdBind = {
    cmd,
    desc,
  }: [
    "<cmd>${cmd}<cr>"
    desc
  ];

  bindings = {
    normal = {
      opts = {
        mode = "n";
        prefix = "<leader>";
        buffer = helpers.mkRaw "nil";
        silent = true;
        noremap = true;
        nowait = true;
      };
      registrations = {
        f = {
          "f" = mkRequireBind {
            module = "telescope.builtin";
            cmd = "find_files";
            desc = "find file";
          };
          "s" = mkRequireBind {
            module = "telescope.builtin";
            cmd = "live_grep";
            desc = "search";
          };
        };
        # quick-binding for find_files
        "F" = mkRequireBind {
          module = "telescope.builtin";
          cmd = "find_files";
          desc = "find file";
        };
        b = {
          name = "buffers";
          f = mkCmdBind {
            cmd = "Telescope buffers";
            desc = "find";
          };
        };
        g = {
          name = "git";
          o = mkCmdBind {
            cmd = "Telescope git_status";
            desc = "find changed files";
          };
          b = mkCmdBind {
            cmd = "Telescope git_branches";
            desc = "checkout branch";
          };
          c = mkCmdBind {
            cmd = "Telescope git_commits";
            desc = "checkout commits";
          };
        };
        l = {
          name = "lsp";
          a = mkCmdBind {
            cmd = "Lspsaga code_action";
            desc = "code action";
          };
          d = mkCmdBind {
            cmd = "lua vim.lsp.buf.definition()";
            desc = "definition";
          };
          f = mkCmdBind {
            cmd = "lua vim.lsp.buf.format()";
            desc = "format";
          };
          h = mkCmdBind {
            cmd = "lua vim.lsp.buf.hover()";
            desc = "hover";
          };
          r = mkCmdBind {
            cmd = "Lspsaga rename";
            desc = "rename";
          };
          u = mkCmdBind {
            cmd = "lua vim.lsp.buf.references()";
            desc = "references";
          };
        };
        t = {
          name = "toggle";
          t = mkCmdBind {
            cmd = "NvimTreeToggle";
            desc = "file tree";
          };
          e = mkCmdBind {
            cmd = "TroubleToggle";
            desc = "trouble";
          };
        };
        c = {
          name = "code";
          a = mkCmdBind {
            cmd = "Lspsaga code_action";
            desc = "code action";
          };
          f = mkCmdBind {
            cmd = "Lspsaga lsp_finder";
            desc = "lsp finder";
          };
        };
      };
    };
    visual = {
      opts = {
        mode = "v";
        prefix = "<leader>";
        buffer = helpers.mkRaw "nil";
        silent = true;
        noremap = true;
        nowait = true;
      };
      registrations = {
        y = {
          name = "yank";
          y = [
            (helpers.mkRaw "visual_yank_without_indent")
            "yank without indent"
          ];
        };
        l = {
          name = "link-to";
          l = [
            (helpers.mkRaw "ghlink_lines")
            "link using line numbers"
          ];
          s = [
            (helpers.mkRaw "ghlink_search")
            "link using search"
          ];
        };
      };
    };
  };
in {
  extraConfigLua = let
    names = builtins.attrNames bindings;
    generateRegistrations = name: let
      registrations = bindings.${name}.registrations;
      opts = bindings.${name}.opts;
    in "require(\"which-key\").register(${helpers.toLuaObject registrations}, ${helpers.toLuaObject opts})";
  in
    builtins.concatStringsSep "\n" (builtins.map generateRegistrations names);

  extraPlugins = [pkgs.vimPlugins.which-key-nvim];
}
