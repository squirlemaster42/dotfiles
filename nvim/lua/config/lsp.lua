-- Global LSP Configuration for Neovim 0.11+
-- Migrated from lsp-zero to native LSP with modern enhancements

local M = {}

-- Enhanced capabilities with snippet support
function M.get_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
    }
    
    return capabilities
end

-- Set diagnostic keymaps globally (works without LSP)
local diagnostic_opts = {remap = false}
vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, diagnostic_opts)
vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, diagnostic_opts)
vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, diagnostic_opts)

-- LSP-specific on_attach function
local function set_diagnostic_keymaps(bufnr)
    local opts = {buffer = bufnr, remap = false}
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
end

-- LSP-specific on_attach function
function M.on_attach(client, bufnr)
    local opts = {buffer = bufnr, remap = false}
    
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.symbols() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    
    -- Also ensure diagnostic keymaps are set buffer-locally
    set_diagnostic_keymaps(bufnr)
end

-- Setup function to enable all servers
function M.setup()
    vim.diagnostic.config({
        virtual_text = true,
        signs = {
            error = 'E',
            warn = 'W',
            hint = 'H',
            info = 'I'
        },
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    })
    
    vim.filetype.add({ 
        extension = { 
            templ = "templ"
        } 
    })
    
    local servers = {
        "ts_ls",
        "rust_analyzer", 
        "gopls",
        "templ",
        "html",
        "htmx"
    }
    
    for _, server in ipairs(servers) do
        local config = require('lsp.' .. server)
        config.capabilities = M.get_capabilities()
        config.on_attach = M.on_attach
        config.flags = { debounce_text_changes = 150 }
        vim.lsp.config(server, config)
    end
    
    vim.lsp.enable(servers)
end

return M
