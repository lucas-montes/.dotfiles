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
