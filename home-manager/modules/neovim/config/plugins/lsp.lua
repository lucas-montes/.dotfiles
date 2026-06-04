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

    -- nvf-style LSP keymaps (<leader>l* prefix)
    opts.desc = "Code action"
    keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts)

    opts.desc = "Go to definition"
    keymap.set("n", "<leader>lgd", vim.lsp.buf.definition, opts)

    opts.desc = "List references"
    keymap.set("n", "<leader>lgr", "<cmd>Telescope lsp_references<CR>", opts)

    opts.desc = "List implementations"
    keymap.set("n", "<leader>lgi", "<cmd>Telescope lsp_implementations<CR>", opts)

    opts.desc = "Go to type definition"
    keymap.set("n", "<leader>lgt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

    opts.desc = "Hover"
    keymap.set("n", "<leader>lh", vim.lsp.buf.hover, opts)

    opts.desc = "Rename"
    keymap.set("n", "<leader>ln", vim.lsp.buf.rename, opts)

    opts.desc = "Format"
    keymap.set("n", "<leader>lf", vim.lsp.buf.format, opts)

    opts.desc = "Diagnostic float"
    keymap.set("n", "<leader>le", vim.diagnostic.open_float, opts)

    opts.desc = "Previous diagnostic"
    keymap.set("n", "<leader>lgp", vim.diagnostic.goto_prev, opts)

    opts.desc = "Next diagnostic"
    keymap.set("n", "<leader>lgn", vim.diagnostic.goto_next, opts)

    opts.desc = "Signature help"
    keymap.set("i", "<C-l>", vim.lsp.buf.signature_help, opts)

    opts.desc = "Document symbols"
    keymap.set("n", "<leader>lS", "<cmd>Telescope lsp_document_symbols<CR>", opts)

    opts.desc = "Workspace symbols"
    keymap.set("n", "<leader>lws", "<cmd>Telescope lsp_workspace_symbols<CR>", opts)

    opts.desc = "Document highlight"
    keymap.set("n", "<leader>lH", vim.lsp.buf.document_highlight, opts)

    opts.desc = "Toggle format on save"
    keymap.set("n", "<leader>ltf", function()
        vim.g.format_on_save = not vim.g.format_on_save
        vim.notify("Format on save: " .. tostring(vim.g.format_on_save))
    end, opts)
end

local capabilities = cmp_nvim_lsp.default_capabilities()

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰠠 ",
            [vim.diagnostic.severity.INFO] = " ",
        },
    },
    underline = true,
    update_in_insert = false,
    virtual_text = true,
})

-- Enable LSP servers using vim.lsp.enable (Neovim 0.11+ API).
-- Only enables a server if its binary is found in PATH.
-- Nix-installed defaults (via extraPackages) provide the fallback,
-- but entering a nix-shell with different tools just works.
vim.lsp.config("*", {
    capabilities = capabilities,
})

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

-- Use LspAttach autocmd instead of on_attach in vim.lsp.config
-- because Neovim 0.11's auto-attach doesn't call on_attach from config correctly
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_on_attach", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
            on_attach(client, args.buf)
        end
    end,
})

-- Per-server overrides
-- on_attach is handled by the LspAttach autocmd above (no double-firing)
vim.lsp.config("nixd", {
    capabilities = capabilities,
    settings = {
        nixd = {
            formatting = { command = { "alejandra" } },
            nixpkgs = { expr = "import <nixpkgs> { }" },
        },
    },
})

vim.lsp.config("rust_analyzer", {
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
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
    capabilities = capabilities,
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
    capabilities = capabilities,
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
