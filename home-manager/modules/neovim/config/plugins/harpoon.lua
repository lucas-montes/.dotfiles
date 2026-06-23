local harpoon = require("harpoon")
harpoon:setup()

-- Add keymaps for harpoon
local keymap = vim.keymap

keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Add file to harpoon" })
keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Toggle harpoon menu" })

keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Go to harpoon file 1" })
keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Go to harpoon file 2" })
keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Go to harpoon file 3" })
keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Go to harpoon file 4" })

keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Go to previous harpoon file" })
keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Go to next harpoon file" })
