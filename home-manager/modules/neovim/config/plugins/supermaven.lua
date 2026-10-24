require("supermaven-nvim").setup({
    binary_path = vim.fn.expand("~/.supermaven/binary/v20/linux-x86_64/sm-agent"),
    keymaps = {
        accept_suggestion = "<C-y>",
        clear_suggestion = "<C-]>",
        next_suggestion = "<C-]>",
    },
    disable_inline_completion = false,
    disable_keymaps = false
})
