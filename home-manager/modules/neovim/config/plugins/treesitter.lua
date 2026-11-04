-- nvim-treesitter's new "main" branch dropped the old configs.setup() API.
-- Parsers are already installed via nix (see default.nix withPlugins), so
-- highlighting/indent just need to be turned on per-buffer with core APIs.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local has_parser = pcall(vim.treesitter.start, args.buf)
    if has_parser then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
