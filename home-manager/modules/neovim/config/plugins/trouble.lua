require("trouble").setup({
    warn_no_results = false,
    win = { position = "bottom" },
    icons = {
        indent = {
            fold_open = "v",
            fold_closed = ">",
        },
    },
    modes = {
        document_diagnostics = {
            desc = "Buffer diagnostics",
            source = "diagnostics",
            filter = { buf = 0 },
        },
        workspace_diagnostics = {
            desc = "Workspace diagnostics",
            source = "diagnostics",
        },
    },
})

local keymap = vim.keymap
keymap.set("n", "<leader>xx", function() require("trouble").toggle("diagnostics") end, { desc = "Toggle trouble" })
keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end, { desc = "Toggle workspace diagnostics" })
keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end, { desc = "Toggle document diagnostics" })
keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end, { desc = "Toggle quickfix" })
keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end, { desc = "Toggle loclist" })
-- gR is in lsp.lua's on_attach (uses Telescope); avoid conflict
