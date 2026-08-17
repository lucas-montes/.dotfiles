{
  config,
  inputs,
  pkgs,
  ...
}: let
  fromPlugin = file: (builtins.readFile "${./config}/plugins/${file}.lua");
in {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withRuby = true;
    withPython3 = true;

    extraPackages = [
      # Lua
      pkgs.lua-language-server # LSP
      pkgs.stylua # formatter
      pkgs.luajitPackages.luacheck # linter

      # Nix
      pkgs.nixd # LSP
      pkgs.alejandra # formatter
      pkgs.statix # linter
      pkgs.deadnix # linter

      # Bash
      pkgs.bash-language-server # LSP
      pkgs.shfmt # formatter
      pkgs.shellcheck # linter

      # Python
      pkgs.ruff # LSP + formatter + linter
      pkgs.pyright # LSP

      # JS/TS
      pkgs.typescript-language-server # LSP

      # Rust
      pkgs.rust-analyzer # LSP

      # Go
      pkgs.gopls # LSP
      pkgs.gofumpt # formatter
      pkgs.golangci-lint # linter

      # Dart/Flutter
      pkgs.dart # LSP + formatter

      # C/C++
      pkgs.clang-tools # LSP + formatter

      # Haskell
      pkgs.haskell-language-server # LSP
      pkgs.fourmolu # formatter
      pkgs.hlint # linter

      # Erlang
      pkgs.erlang-language-platform # LSP
      pkgs.erlfmt # formatter

      # OCaml
      pkgs.ocamlPackages.ocaml-lsp # LSP
      pkgs.ocamlformat # formatter

      # SQL
      pkgs.sqls # LSP

      # Nushell
      pkgs.nushell # LSP + formatter

      # Markdown
      pkgs.markdownlint-cli2 # linter

      # Clipboards
      pkgs.xclip
      pkgs.wl-clipboard
    ];

    plugins = with pkgs.vimPlugins; let
      mkVimPlugin = plugin: {
        inherit plugin;
        type = "viml";
      };
    in [
      {
        plugin = undotree;
        type = "lua";
        config = ''
          vim.g.mapleader = ' '
          vim.g.maplocalleader = ' '
        '';
      }

      {
        plugin = which-key-nvim;
        type = "lua";
        config = fromPlugin "whichkey";
      }

      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = fromPlugin "lsp";
      }

      {
        plugin = comment-nvim;
        type = "lua";
        config = ''require("Comment").setup()'';
      }

      {
        plugin = nvim-cmp;
        type = "lua";
        config = fromPlugin "cmp";
      }

      {
        plugin = telescope-nvim;
        type = "lua";
        config = fromPlugin "telescope";
      }

      (mkVimPlugin telescope-fzf-native-nvim)

      (mkVimPlugin cmp_luasnip)
      (mkVimPlugin cmp-nvim-lsp)

      (mkVimPlugin luasnip)
      (mkVimPlugin friendly-snippets)

      {
        plugin = lualine-nvim;
        type = "lua";
        config = fromPlugin "lualine";
      }
      (mkVimPlugin nvim-web-devicons)

      {
        plugin = nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-lua
          p.tree-sitter-python
          p.tree-sitter-json
          p.tree-sitter-rust
          p.tree-sitter-html
          p.tree-sitter-css
          p.tree-sitter-javascript
          p.tree-sitter-typescript
          p.tree-sitter-go
          p.tree-sitter-toml
          p.tree-sitter-yaml
          p.tree-sitter-markdown
          p.tree-sitter-markdown-inline
          p.tree-sitter-sql
          p.tree-sitter-dart
          p.tree-sitter-c
          p.tree-sitter-haskell
          p.tree-sitter-erlang
          p.tree-sitter-ocaml
          p.tree-sitter-vue
        ]);
        type = "lua";
        config = fromPlugin "treesitter";
      }

      (mkVimPlugin vim-nix)

      {
        plugin = harpoon2;
        type = "lua";
        config = fromPlugin "harpoon";
      }

      {
        plugin = trouble-nvim;
        type = "lua";
        config = fromPlugin "trouble";
      }

      {
        plugin = todo-comments-nvim;
        type = "lua";
        config = fromPlugin "todo-comments";
      }

      {
        plugin = supermaven-nvim;
        type = "lua";
        config = fromPlugin "supermaven";
      }

      {
        plugin = conform-nvim;
        type = "lua";
        config = fromPlugin "conform";
      }

      {
        plugin = nvim-lint;
        type = "lua";
        config = ''
          require("lint").linters_by_ft = {
            nix = { "statix", "deadnix" },
            python = { "ruff" },
            lua = { "luacheck" },
            bash = { "shellcheck" },
            sh = { "shellcheck" },
            zsh = { "shellcheck" },
            go = { "golangci-lint" },
            markdown = { "markdownlint-cli2" },
            dart = { "dartanalyzer" },
            c = { "cpplint" },
            cpp = { "cpplint" },
            haskell = { "hlint" },
          }

          vim.api.nvim_create_autocmd("BufWritePost", {
            callback = function()
              require("lint").try_lint()
            end,
          })
        '';
      }
    ];

    initLua = ''
      ${builtins.readFile ./config/options.lua}
    '';
  };
}
