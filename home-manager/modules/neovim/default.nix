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
      # Formatters
      alejandra
      # Clipboards
      xclip
      wl-clipboard
    ];

    plugins = with pkgs.vimPlugins; [
      undotree

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
              rust = { "rustfmt", lsp_format = "fallback" },
              javascript = { "prettierd", "prettier", lsp_format = "fallback" },
              typescript = { "prettierd", "prettier", lsp_format = "fallback" },
              javascriptreact = { "prettierd", "prettier", lsp_format = "fallback" },
              typescriptreact = { "prettierd", "prettier", lsp_format = "fallback" },
              json = { "prettierd", "prettier" },
              yaml = { "prettierd", "prettier" },
              markdown = { "prettierd", "prettier" },
              bash = { "shfmt", "beautysh" },
              ["*"] = { lsp_format = "fallback" },
            },
            format_on_save = {
              timeout_ms = 500,
              lsp_format = "fallback",
            },
          })
        '';
      }
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./config/options.lua}
    '';
  };
}
