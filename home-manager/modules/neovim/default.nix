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

    extraPackages = with pkgs; [
      # LSP servers
      lua-language-server
      nixd
      bash-language-server
      typescript-language-server
      ruff
      pyright
      rust-analyzer
      # Formatters (nvf defaults)
      alejandra
      stylua
      shfmt
      gofumpt
      # Extra linters (nvf defaults: enableExtraDiagnostics)
      statix
      deadnix
      shellcheck
      luajitPackages.luacheck
      nodePackages.markdownlint-cli2
      golangci-lint
      # Clipboards
      xclip
      wl-clipboard
    ];

    plugins = with pkgs.vimPlugins; [
      {
        plugin = undotree;
        config = toLua ''
          vim.g.mapleader = ' '
          vim.g.maplocalleader = ' '
        '';
      }

      {
        plugin = mini-nvim;
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
        config = fromPlugin "whichkey";
      }

      {
        plugin = nvim-lspconfig;
        config = fromPlugin "lsp";
      }

      {
        plugin = comment-nvim;
        config = toLua ''require("Comment").setup()'';
      }

      {
        plugin = nvim-cmp;
        config = fromPlugin "cmp";
      }

      {
        plugin = telescope-nvim;
        config = fromPlugin "telescope";
      }

      telescope-fzf-native-nvim

      cmp_luasnip
      cmp-nvim-lsp

      luasnip
      friendly-snippets

      {
        plugin = lualine-nvim;
        config = fromPlugin "lualine-config";
      }
      nvim-web-devicons

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
        ]);
        config = fromPlugin "treesitter";
      }

      vim-nix

      {
        plugin = harpoon2;
        config = fromPlugin "harpoon";
      }

      {
        plugin = trouble-nvim;
        config = fromPlugin "trouble";
      }

      {
        plugin = todo-comments-nvim;
        config = fromPlugin "todo-comments";
      }

      supermaven-nvim

      {
        plugin = conform-nvim;
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
            },
            default_format_opts = {
              lsp_format = "fallback",
            },
            format_on_save = {
              timeout_ms = 500,
              lsp_format = "fallback",
            },
          })
        '';
      }

      {
        plugin = nvim-lint;
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
          }

          vim.api.nvim_create_autocmd("BufWritePost", {
            callback = function()
              require("lint").try_lint()
            end,
          })
        '';
      }
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./config/options.lua}
    '';
  };
}
