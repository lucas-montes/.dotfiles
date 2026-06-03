local cmp_nvim_lsp = require("cmp_nvim_lsp")

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

local on_attach = function(client, bufnr)
    opts.buffer = bufnr

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    opts.desc = "Show LSP references"
    keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

    opts.desc = "Go to declaration"
    keymap.set("n", "gd", vim.lsp.buf.declaration, opts)

    opts.desc = "Show LSP definitions"
    keymap.set("n", "gD", "<cmd>Telescope lsp_definitions<CR>", opts)

    opts.desc = "Show LSP implementations"
    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

    opts.desc = "Show LSP type definitions"
    keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

    opts.desc = "See available code actions"
    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

    opts.desc = "Smart rename"
    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

    opts.desc = "Show buffer diagnostics"
    keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

    opts.desc = "Show line diagnostics"
    keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

    opts.desc = "Go to previous diagnostic"
    keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

    opts.desc = "Go to next diagnostic"
    keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

    opts.desc = "Show documentation for what is under cursor"
    keymap.set("n", "K", vim.lsp.buf.hover, opts)

    opts.desc = "Restart LSP"
    keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
end

local capabilities = cmp_nvim_lsp.default_capabilities()

local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Enable LSP servers using the nvim 0.11+ API (vim.lsp.enable).
-- nvim-lspconfig registers its server configs with vim.lsp.config,
-- so this is the correct API. require("lspconfig").setup() is deprecated.
--
-- Only enables a server if its binary is found in PATH.
-- Nix-installed defaults (via extraPackages) provide the fallback,
-- but entering a nix-shell with different tools just works.
local servers = {
    "bashls", "ts_ls", "ruff", "nixd", "buf_ls", "volar",
    "pyright", "rust_analyzer", "lua_ls",
}

local server_cmds = {
    bashls = "bash-language-server",
    ts_ls = "typescript-language-server",
    ruff = "ruff",
    nixd = "nixd",
    buf_ls = "buf",
    volar = "vue-language-server",
    pyright = "pyright",
    rust_analyzer = "rust-analyzer",
    lua_ls = "lua-language-server",
}

for _, name in ipairs(servers) do
    if vim.fn.executable(server_cmds[name]) == 1 then
        vim.lsp.enable(name)
    end
end

-- Defaults applied to every LSP client
vim.lsp.config("*", {
    on_attach = on_attach,
    capabilities = capabilities,
})

-- Per-server overrides
vim.lsp.config("nixd", {
    settings = {
        nixd = {
            formatting = { command = { "alejandra" } },
            nixpkgs = { expr = "import <nixpkgs> { }" },
        },
    },
})

vim.lsp.config("rust_analyzer", {
    settings = {
        ["rust-analyzer"] = {
            diagnostics = { enable = false },
            inlayHints = {
                enable = true,
                showParameterNames = true,
                parameterHintsPrefix = "<- ",
                otherHintsPrefix = "=> ",
            },
        },
    },
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                },
            },
        },
    },
})

vim.lsp.config("pyright", {
    settings = {
        pyright = {
            disableOrganizeImports = false,
            analysis = {
                useLibraryCodeForTypes = true,
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                autoImportCompletions = true,
            },
        },
    },
})
