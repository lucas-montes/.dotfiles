require("trouble").setup({
    icons = true,
    fold = {
        open = "v", -- icon used for open folds
        closed = ">", -- icon used for closed folds
    },
})

local keymap = vim.keymap
keymap.set("n", "<leader>xx", function() require("trouble").toggle() end, { desc = "Toggle trouble" })
keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end, { desc = "Toggle workspace diagnostics" })
keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end, { desc = "Toggle document diagnostics" })
keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end, { desc = "Toggle quickfix" })
keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end, { desc = "Toggle loclist" })
keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end, { desc = "LSP references" })
