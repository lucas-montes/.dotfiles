local palette = require('mini.base16').config.palette

local lualine_theme = {
    -- NORMAL mode (default bar state)
    normal   = {
        a = { fg = palette.base00, bg = palette.base0D }, -- section a (mode): blue
        b = { fg = palette.base05, bg = palette.base01 }, -- section b (file + progress + LSP)
        c = { fg = palette.base05, bg = palette.base00 }, -- section c (center)
        x = { fg = palette.base05, bg = palette.base00 }, -- section x (center)
        y = { fg = palette.base05, bg = palette.base01 }, -- section y (diag)
        z = { fg = palette.base00, bg = palette.base09 }, -- section z (changes + branch): blue
    },
    -- MODE-SPECIFIC overrides: only section 'a' (mode) gets a colored bg
    -- Sections b/c/x/y/z use normal mode colors (black bar)
    insert   = { a = { fg = palette.base00, bg = palette.base08 } }, -- mode bg: purple
    visual   = { a = { fg = palette.base00, bg = palette.base0C } }, -- mode bg: cyan
    replace  = { a = { fg = palette.base00, bg = palette.base08 } }, -- mode bg: pinker
    command  = { a = { fg = palette.base00, bg = palette.base0A } }, -- mode bg: green-blue
    -- INACTIVE: shows basic info on darker bg
    inactive = {
        a = { fg = palette.base05, bg = palette.base00 },
        b = { fg = palette.base05, bg = palette.base00 },
        c = { fg = palette.base05 },
    },
}

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = lualine_theme,
        component_separators = '',
        section_separators = { left = '', right = '' },
        globalstatus = true,
        refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
        always_divide_middle = true,
        ignore_focus = { "NvimTree" },
        disabled_filetypes = { statusline = { "alpha" }, winbar = {} },
    },
    sections = {
        lualine_a = {
            { "mode", icons_enabled = true, separator = { left = '', right = '' }, right_padding = 2 },
        },
        lualine_b = {
            { "filename", symbols = { modified = " ", readonly = " " } },
            { "progress" },
            { "location" },
            { "filetype", colored = true, icon_only = true, icon = { align = "right" } },
            { function()
                local buf_ft = vim.bo.filetype
                local excluded_buf_ft = { toggleterm = true, NvimTree = true, ["neo-tree"] = true, TelescopePrompt = true }
                if excluded_buf_ft[buf_ft] then return "" end
                local bufnr = vim.api.nvim_get_current_buf()
                local clients = vim.lsp.get_clients({ bufnr = bufnr })
                if vim.tbl_isempty(clients) then return "No Active LSP" end
                local active_clients = {}
                for _, client in ipairs(clients) do table.insert(active_clients, client.name) end
                return table.concat(active_clients, ", ")
            end, separator = { right = "" } },
        },
        lualine_c = {
            -- center: black background
            { "searchcount", maxcount = 999, timeout = 120 },
        },
        lualine_x = {
            -- center: black background
        },
        lualine_y = {
            { "diagnostics", sources = { "nvim_lsp", "nvim_diagnostic", "vim_lsp" },
                symbols = { error = "󰅙 ", warn = " ", info = " ", hint = "󰌵 " },
                colored = true, update_in_insert = false, always_visible = false,
                diagnostics_color = { color_error = { fg = palette.base08 }, color_warn = { fg = palette.base0B }, color_info = { fg = palette.base0C } },
                separator = { left = '' },
            },
        },
        lualine_z = {
            { "diff", colored = false,
                diff_color = { added = "DiffAdd", modified = "DiffChange", removed = "DiffDelete" },
                symbols = { added = "+", modified = "~", removed = "-" },
                color = { fg = palette.base00, bg = palette.base09 } },
            { "branch", icon = " •", separator = { left = '', right = '' }, left_padding = 2,
                color = function(branch)
                    if branch == "master" or branch == "main" then
                        return { fg = palette.base00, bg = palette.base0C }
                    else
                        return { fg = palette.base00, bg = palette.base08 }
                    end
                end },
        },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
}
