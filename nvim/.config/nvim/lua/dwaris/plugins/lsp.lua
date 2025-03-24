return {
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                { path = 'luvit-meta/library', words = { 'vim%.uv' } },
            },
        },
    },
    { 'Bilal2453/luvit-meta', lazy = true },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'stevearc/conform.nvim',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'j-hui/fidget.nvim',
        },

        config = function()
            require('conform').setup {
                formatters_by_ft = {
                    lua = { 'stylua' },
                    go = { 'gofmt' },
                    python = { 'black' },
                    rust = { 'rustfmt' },
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_format = 'fallback',
                },
            }
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or 'n'
                        vim.keymap.set(
                            mode,
                            keys,
                            func,
                            { buffer = event.buf, desc = 'LSP: ' .. desc }
                        )
                    end

                    map(
                        'gd',
                        require('telescope.builtin').lsp_definitions,
                        '[G]oto [D]efinition'
                    )

                    map(
                        'gr',
                        require('telescope.builtin').lsp_references,
                        '[G]oto [R]eferences'
                    )

                    map(
                        'gI',
                        require('telescope.builtin').lsp_implementations,
                        '[G]oto [I]mplementation'
                    )

                    map(
                        '<leader>D',
                        require('telescope.builtin').lsp_type_definitions,
                        'Type [D]efinition'
                    )

                    map(
                        '<leader>ds',
                        require('telescope.builtin').lsp_document_symbols,
                        '[D]ocument [S]ymbols'
                    )

                    map(
                        '<leader>ws',
                        require('telescope.builtin').lsp_dynamic_workspace_symbols,
                        '[W]orkspace [S]ymbols'
                    )

                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

                    map(
                        '<leader>ca',
                        vim.lsp.buf.code_action,
                        '[C]ode [A]ction',
                        { 'n', 'x' }
                    )

                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                    map('K', vim.lsp.buf.hover, 'Hover Documentation')
                    map('<leader>f', function()
                        require('conform').format()
                    end, '[F]ormat')
                end,
            })

            local cmp = require 'cmp'
            local lspconfig = require 'lspconfig'

            local function setup_server(server, config)
                if not lspconfig[server] then
                    vim.notify(
                        'LSP-Server ' .. server .. ' not found!',
                        vim.log.levels.WARN
                    )
                    return
                end
                lspconfig[server].setup(config or {})
            end

            setup_server('rust_analyzer', {
                settings = {
                    ['rust-analyzer'] = { checkOnSave = { command = 'clippy' } },
                },
            })
            setup_server('gopls', {})
            setup_server('pyright', {})
            setup_server('marksman', {})
            setup_server('bashls', {})
            setup_server('lua_ls', {
                settings = {
                    Lua = {
                        completion = { callSnippet = 'Replace' },
                        diagnostics = {
                            globals = { 'vim' },
                        },
                    },
                },
            })
            setup_server('nil_ls', {
                settings = {
                    ['nil'] = {
                        formatting = { command = { 'alejandra' } },
                        nix = { flake = { autoArchive = false } },
                    },
                },
            })

            require('fidget').setup {}

            cmp.setup {
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },

                completion = { completeopt = 'menu,menuone,noinsert' },

                mapping = cmp.mapping.preset.insert {
                    ['<C-p>'] = cmp.mapping.select_prev_item {},
                    ['<C-n>'] = cmp.mapping.select_next_item {},
                    ['<C-y>'] = cmp.mapping.confirm {
                        select = true,
                    },
                    ['<C-Space>'] = cmp.mapping.complete {},
                    -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    -- ['<C-f>'] = cmp.mapping.scroll_docs(4), same binding as tmux
                },

                sources = cmp.config.sources {
                    { name = 'copilot', group_index = 2 },
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    { name = 'buffer' },
                    { name = 'nvim_lsp_signature_help' },
                },
            }
        end,
    },
}
