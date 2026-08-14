{
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (config.lib.stylix) colors;
  toLua = str: ''
    lua << EOF
    ${str}
    EOF
  '';
  toLuaFile = file: toLua (builtins.readFile "${./config}/${file}.lua");
  fromPlugin = file: toLuaFile "plugins/${file}";
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
      pkgs.lua-language-server           # LSP
      pkgs.stylua                        # formatter
      pkgs.luajitPackages.luacheck       # linter

      # Nix
      pkgs.nixd                          # LSP
      pkgs.alejandra                     # formatter
      pkgs.statix                        # linter
      pkgs.deadnix                       # linter

      # Bash
      pkgs.bash-language-server          # LSP
      pkgs.shfmt                         # formatter
      pkgs.shellcheck                    # linter

      # Python
      pkgs.ruff                          # LSP + formatter + linter
      pkgs.pyright                       # LSP

      # JS/TS
      pkgs.typescript-language-server    # LSP

      # Rust
      pkgs.rust-analyzer                 # LSP

      # Go
      pkgs.gopls                         # LSP
      pkgs.gofumpt                       # formatter
      pkgs.golangci-lint                 # linter

      # Dart/Flutter
      pkgs.dart                          # LSP + formatter

      # C/C++
      pkgs.clang-tools                   # LSP + formatter

      # Haskell
      pkgs.haskell-language-server       # LSP
      pkgs.fourmolu                      # formatter
      pkgs.hlint                         # linter

      # Erlang
      pkgs.erlang-language-platform      # LSP
      pkgs.erlfmt                        # formatter

      # OCaml
      pkgs.ocamlPackages.ocaml-lsp       # LSP
      pkgs.ocamlformat                   # formatter

      # SQL
      pkgs.sqls                          # LSP

      # Nushell
      pkgs.nushell                       # LSP + formatter

      # Markdown
      pkgs.markdownlint-cli2              # linter

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
        type = "viml";
        config = toLua ''
          vim.g.mapleader = ' '
          vim.g.maplocalleader = ' '
        '';
      }

      {
        plugin = mini-nvim;
        type = "viml";
        config = toLua ''
          require('mini.base16').setup({
            palette = {
              base00 = '#${colors.base00}',
              base01 = '#${colors.base01}',
              base02 = '#${colors.base02}',
              base03 = '#${colors.base03}',
              base04 = '#${colors.base04}',
              base05 = '#${colors.base05}',
              base06 = '#${colors.base06}',
              base07 = '#${colors.base07}',
              base08 = '#${colors.base08}',
              base09 = '#${colors.base09}',
              base0A = '#${colors.base0A}',
              base0B = '#${colors.base0B}',
              base0C = '#${colors.base0C}',
              base0D = '#${colors.base0D}',
              base0E = '#${colors.base0E}',
              base0F = '#${colors.base0F}',
            },
          })
        '';
      }

      {
        plugin = which-key-nvim;
        type = "viml";
        config = fromPlugin "whichkey";
      }

      {
        plugin = nvim-lspconfig;
        type = "viml";
        config = fromPlugin "lsp";
      }

      {
        plugin = comment-nvim;
        type = "viml";
        config = toLua ''require("Comment").setup()'';
      }

      {
        plugin = nvim-cmp;
        type = "viml";
        config = fromPlugin "cmp";
      }

      {
        plugin = telescope-nvim;
        type = "viml";
        config = fromPlugin "telescope";
      }

      (mkVimPlugin telescope-fzf-native-nvim)

      (mkVimPlugin cmp_luasnip)
      (mkVimPlugin cmp-nvim-lsp)

      (mkVimPlugin luasnip)
      (mkVimPlugin friendly-snippets)

      {
        plugin = lualine-nvim;
        type = "viml";
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
        type = "viml";
        config = fromPlugin "treesitter";
      }

      (mkVimPlugin vim-nix)

      {
        plugin = harpoon2;
        type = "viml";
        config = fromPlugin "harpoon";
      }

      {
        plugin = trouble-nvim;
        type = "viml";
        config = fromPlugin "trouble";
      }

      {
        plugin = todo-comments-nvim;
        type = "viml";
        config = fromPlugin "todo-comments";
      }

      {
        plugin = supermaven-nvim;
        type = "viml";
        config = fromPlugin "supermaven";
      }

      {
        plugin = conform-nvim;
        type = "viml";
        config = toLua ''
          require("conform").setup({
            formatters_by_ft = {
              nix = { "alejandra", "nixfmt", "nixpkgs-fmt" },
              python = { "ruff_format", "ruff_fix", "black" },
              lua = { "stylua" },
              rust = { "rustfmt" },
              go = { "gofumpt", "goimports" },
              javascript = { "prettierd", "prettier" },
              typescript = { "prettierd", "prettier" },
              javascriptreact = { "prettierd", "prettier" },
              typescriptreact = { "prettierd", "prettier" },
              json = { "prettierd", "prettier" },
              yaml = { "prettierd", "prettier" },
              markdown = { "prettierd", "prettier", "mdformat" },
              bash = { "shfmt", "beautysh" },
              html = { "prettierd", "prettier" },
              css = { "prettierd", "prettier" },
              sql = { "sqlfluff", "sqruff" },
              toml = { "taplo" },
              dart = { "dart_format" },
              flutter = { "dart_format" },
              ocaml = { "ocamlformat" },
              c = { "clang-format" },
              cpp = { "clang-format" },
              haskell = { "fourmolu", "ormolu" },
              erlang = { "erlfmt" },
              nu = { "nu" },
            },
            default_format_opts = {
              lsp_format = "fallback",
            },
            -- format_on_save is disabled; use <leader>lf to format manually
            -- format_on_save = {
            --   timeout_ms = 500,
            --   lsp_format = "fallback",
            -- },
          })
        '';
      }

      {
        plugin = nvim-lint;
        type = "viml";
        config = toLua ''
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
