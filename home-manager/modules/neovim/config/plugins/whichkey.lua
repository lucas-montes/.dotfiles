require("which-key").setup({
    preset = "helix",
    icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
    },
    spec = {},
})

require("which-key").add {
    { "<leader><leader>", group = "buffer" },
    { "<leader><leader>_", hidden = true },
    { "<leader>c", group = "code" },
    { "<leader>c_", hidden = true },
    { "<leader>d", group = "document" },
    { "<leader>d_", hidden = true },
    { "<leader>g", group = "git" },
    { "<leader>g_", hidden = true },
    { "<leader>m", group = "markdown" },
    { "<leader>m_", hidden = true },
    { "<leader>r", group = "rename" },
    { "<leader>r_", hidden = true },
    { "<leader>s", group = "search" },
    { "<leader>s_", hidden = true },
    { "<leader>t", group = "toggle" },
    { "<leader>t_", hidden = true },
    { "<leader>w", group = "workspace" },
    { "<leader>w_", hidden = true },
    { "<leader>l", group = "LSP" },
    { "<leader>l_", hidden = true },
    { "<leader>x", group = "diagnostics" },
    { "<leader>x_", hidden = true },
}
