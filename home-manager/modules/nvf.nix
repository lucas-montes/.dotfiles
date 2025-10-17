{inputs, ...}: {
  imports = [inputs.nvf.homeManagerModules.default];
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        assistant.supermaven-nvim.enable = true;
        withNodeJs = false;
        navigation = {harpoon = {enable = true;};};
        notes.todo-comments.enable = true;
        options = {
          wrap = false;
          shiftwidth = 4;
          tabstop = 4;
          # Disable backup, swap, and writebackup files
          backup = false;
          writebackup = false;
          swapfile = false;

          # Alternatively, store swap and backup files in /tmp
          directory = "/tmp"; # For swap files
          backupdir = "/tmp"; # For backup files
        };
        undoFile = {
          enable = true;
          path = "/tmp";
        };
        binds = {
          whichKey.enable = true;
        };
        keymaps = [
          {
            key = "<leader>y";
            mode = ["n" "v"];
            silent = true;
            action = "\"+y";
          }
          {
            key = "<leader>pv";
            mode = "n";
            silent = true;
            action = ":Ex<CR>";
          }
        ];
        lsp = {
          enable = true;
          trouble.enable = true;
        };
        viAlias = true;
        vimAlias = true;
        statusline.lualine = {
          enable = true;
          theme = "base16";
        };
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;

        languages = {
          enableExtraDiagnostics = true;
          enableFormat = true;
          enableTreesitter = true;
          bash.enable = true;
          nix.enable = true;
          lua.enable = true;
          nu.enable = true;
          clang.enable = true;
          sql.enable = true;
          rust.enable = true;
          html.enable = true;
          css.enable = false;
          ts.enable = false;
          python.enable = true;
        };
      };
    };
  };
}
