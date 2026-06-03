require("supermaven-nvim").setup({
    keymaps = {
        accept_suggestion = "<C-y>",
        clear_suggestion = "<C-]>",
        next_suggestion = "<C-]>",
    },
    ignore_filetypes = { cpp = true },
    disable_inline_completion = false,
    disable_keymaps = false
})
