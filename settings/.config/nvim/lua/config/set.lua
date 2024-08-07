local opt = vim.opt

vim.g.python3_host_prog = "/home/lucas/miniconda3/envs/neo/bin/python"
vim.g.python_host_prog = "/home/lucas/miniconda3/envs/neo/bin/python"

opt.guicursor = ""
opt.nu = true
opt.relativenumber = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
vim.api.nvim_set_option("clipboard","unnamed") 
opt.smartindent = true

opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")

opt.updatetime = 50

opt.colorcolumn = "100"

opt.spelllang = 'en,fr,es'
--opt.spell = true
