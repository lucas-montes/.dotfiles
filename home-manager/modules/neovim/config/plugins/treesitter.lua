local ok, treesitter_configs = xpcall(function()
  return require("nvim-treesitter.configs")
end, debug.traceback)

if not ok then
  vim.api.nvim_err_writeln("nvim-treesitter failed to load:\n" .. tostring(treesitter_configs))
  return
end

treesitter_configs.setup {
  ensure_installed = {},

  auto_install = false,

  highlight = { enable = true },

  indent = { enable = true },
}
