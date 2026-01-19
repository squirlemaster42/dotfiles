return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter').install({
                'vimdoc',
                'javascript',
                'typescript',
                'c',
                'lua',
                'rust',
                'go',
                'templ'
            })
        end
    },

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")

            -- Basic setup
            harpoon:setup()

            -- Keymaps
            vim.keymap.set("n", "<leader>a", function()
                harpoon:list():add()
            end)

            vim.keymap.set("n", "<C-e>", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end)

            vim.keymap.set("n", "<C-h>", function()
                harpoon:list():select(1)
            end)

            vim.keymap.set("n", "<C-t>", function()
                harpoon:list():select(2)
            end)

            vim.keymap.set("n", "<C-n>", function()
                harpoon:list():select(3)
            end)

            vim.keymap.set("n", "<C-s>", function()
                harpoon:list():select(4)
            end)
        end
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd("colorscheme rose-pine")
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        end
    },

    {
        'nvim-telescope/telescope.nvim', tag = 'v0.2.1',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- optional but recommended
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        }
    },

    {
        "ThePrimeagen/refactoring.nvim",
        event = {"BufReadPre", "BufNewFile"},  -- Proper lazy loading
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        keys = {
            -- Refactor key group
            {"<leader>r", "", desc = "+refactor", mode = {"n", "x"}},

            -- Your exact inline variable mapping
            {
                "<leader>ri",
                function()
                    return require("refactoring").refactor("Inline Variable")
                end,
                mode = "v",  -- Visual mode as requested
                desc = "Inline Variable",
                expr = true,
            },

            -- Additional useful refactoring mappings (recommended)
            {
                "<leader>rr",
                function()
                    require('refactoring').select_refactor()
                end,
                mode = {"n", "x"},
                desc = "Select Refactor",
            },
            {
                "<leader>rf",
                function()
                    return require("refactoring").refactor("Extract Function")
                end,
                mode = {"n", "x"},
                desc = "Extract Function",
                expr = true,
            },
            {
                "<leader>rb",
                function()
                    return require("refactoring").refactor("Extract Block")
                end,
                mode = {"n", "x"},
                desc = "Extract Block",
                expr = true,
            },
            {
                "<leader>rx",
                function()
                    return require("refactoring").refactor("Extract Variable")
                end,
                mode = {"n", "x"},
                desc = "Extract Variable",
                expr = true,
            },
        },

        -- Comprehensive configuration with all features
        opts = {
            prompt_func_return_type = {
                go = false, java = false, cpp = false, c = false,
                h = false, hpp = false, cxx = false,
            },
            prompt_func_param_type = {
                go = false, java = false, cpp = false, c = false,
                h = false, hpp = false, cxx = false,
            },
            printf_statements = {},
            print_var_statements = {},
            show_success_message = true,
        },

        -- Setup function with optional telescope integration
        config = function(_, opts)
            require("refactoring").setup(opts)

            -- Optional: Load telescope extension when available
            local ok, telescope = pcall(require, "telescope")
            if ok then
                telescope.load_extension("refactoring")
            end
        end,
    },

    {
        "ThePrimeagen/99",

        config = function()
            local _99 = require("99")

            -- For logging that is to a file if you wish to trace through requests
            -- for reporting bugs, i would not rely on this, but instead the provided
            -- logging mechanisms within 99.  This is for more debugging purposes
            local cwd = vim.uv.cwd()
            local basename = vim.fs.basename(cwd)
            _99.setup({
                logger = {
                    level = _99.DEBUG,
                    path = "/tmp/" .. basename .. ".99.debug",
                    print_on_error = true,
                },

                --- WARNING: if you change cwd then this is likely broken
                --- ill likely fix this in a later change
                ---
                --- md_files is a list of files to look for and auto add based on the location
                --- of the originating request.  That means if you are at /foo/bar/baz.lua
                --- the system will automagically look for:
                --- /foo/bar/AGENT.md
                --- /foo/AGENT.md
                --- assuming that /foo is project root (based on cwd)
                md_files = {
                    "AGENT.md",
                },
            })

            -- Create your own short cuts for the different types of actions
            vim.keymap.set("n", "<leader>9f", function()
                _99.fill_in_function()
            end)
            -- take extra note that i have visual selection only in v mode
            -- technically whatever your last visual selection is, will be used
            -- so i have this set to visual mode so i dont screw up and use an
            -- old visual selection
            --
            -- likely ill add a mode check and assert on required visual mode
            -- so just prepare for it now
            vim.keymap.set("v", "<leader>9v", function()
                _99.visual()
            end)

            --- if you have a request you dont want to make any changes, just cancel it
            vim.keymap.set("v", "<leader>9s", function()
                _99.stop_all_requests()
            end)

            --- Example: Using rules + actions for custom behaviors
            --- Create a rule file like ~/.rules/debug.md that defines custom behavior.
            --- For instance, a "debug" rule could automatically add printf statements
            --- throughout a function to help debug its execution flow.
            vim.keymap.set("n", "<leader>9fd", function()
                _99.fill_in_function()
            end)
        end,
    },

    { "rafamadriz/friendly-snippets" },

    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xq", 
                "<cmd>TroubleToggle quickfix<cr>",
                {silent = true, noremap = true}
            },
        },
    },



    { "nvim-treesitter/nvim-treesitter-context" },

    -- Lua
    {
        "folke/zen-mode.nvim",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },

    {
        "mbbill/undotree",
        keys = {
            {
                "<leader>u",
                vim.cmd.UndotreeToggle,
                desc = "Toggle Undotree",
            },
        },
    },

    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },

    {
        "tpope/vim-fugitive",
        config = function()
            -- Create augroup for Fugitive
            local ThePrimeagen_Fugitive = vim.api.nvim_create_augroup("ThePrimeagen_Fugitive", {})

            -- Set up autocmd for fugitive buffers
            local autocmd = vim.api.nvim_create_autocmd
            autocmd("BufWinEnter", {
                group = ThePrimeagen_Fugitive,
                pattern = "*",
                callback = function()
                    if vim.bo.ft ~= "fugitive" then
                        return
                    end

                    local bufnr = vim.api.nvim_get_current_buf()
                    local opts = {buffer = bufnr, remap = false}
                    vim.keymap.set("n", "<leader>p", function()
                        vim.cmd.Git('push')
                    end, opts)

                    -- rebase always
                    vim.keymap.set("n", "<leader>P", function()
                        vim.cmd.Git({'pull',  '--rebase'})
                    end, opts)

                    -- NOTE: It allows me to easily set the branch i am pushing and any tracking
                    -- needed if i did not set the branch up correctly
                    vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
                end,
            })
        end
    },

    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp"
    },

    { "neovim/nvim-lspconfig" },

    { "hrsh7th/cmp-buffer" },

    { "hrsh7th/cmp-nvim-lua" },

    { "hrsh7th/cmp-path" },

    { "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "saadparwaiz1/cmp_luasnip",
        "L3MON4D3/LuaSnip",
    },
    config = function()
        local cmp = require('cmp')
        local cmp_select = {behavior = cmp.SelectBehavior.Select}

        -- Enhanced source configuration with prioritization
        cmp.setup({
            sources = cmp.config.sources({
                { name = "nvim_lsp", priority = 1000 },
                { name = "luasnip", priority = 750 },
                { name = "nvim_lua", priority = 500 },
                { name = "path", priority = 250 },
                { name = "buffer", priority = 100 },
            }),
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif require("luasnip").expand_or_locally_jumpable() then
                        require("luasnip").expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif require("luasnip").locally_jumpable(-1) then
                        require("luasnip").jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            experimental = {
                ghost_text = true,
            },
        })
    end
},
}
