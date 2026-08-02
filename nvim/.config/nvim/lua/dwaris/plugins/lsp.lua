return {
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        },
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'mason-org/mason.nvim', opts = {} },
            'mason-org/mason-lspconfig.nvim',
        },
        config = function()
            local lsp_attach_group =
                vim.api.nvim_create_augroup('lsp-attach', { clear = true })
            local lsp_highlight_group =
                vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            local lsp_detach_group =
                vim.api.nvim_create_augroup('lsp-detach', { clear = true })

            local function map(event, keys, func, desc, mode)
                mode = mode or 'n'
                vim.keymap.set(mode, keys, func, {
                    buffer = event.buf,
                    desc = 'LSP: ' .. desc,
                })
            end

            local function setup_document_highlight(client, event)
                if not client then
                    return
                end

                if
                    not client:supports_method(
                        vim.lsp.protocol.Methods.textDocument_documentHighlight,
                        event.buf
                    )
                then
                    return
                end

                vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                    buffer = event.buf,
                    group = lsp_highlight_group,
                    callback = vim.lsp.buf.document_highlight,
                })

                vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                    buffer = event.buf,
                    group = lsp_highlight_group,
                    callback = vim.lsp.buf.clear_references,
                })

                vim.api.nvim_create_autocmd('LspDetach', {
                    group = lsp_detach_group,
                    callback = function(event2)
                        vim.lsp.buf.clear_references()
                        vim.api.nvim_clear_autocmds {
                            group = 'lsp-highlight',
                            buffer = event2.buf,
                        }
                    end,
                })
            end

            vim.api.nvim_create_autocmd('LspAttach', {
                group = lsp_attach_group,
                callback = function(event)
                    map(event, 'grn', vim.lsp.buf.rename, '[R]e[n]ame')
                    map(
                        event,
                        'gra',
                        vim.lsp.buf.code_action,
                        '[G]oto Code [A]ction',
                        { 'n', 'x' }
                    )
                    map(
                        event,
                        'grr',
                        vim.lsp.buf.references,
                        '[G]oto [R]eferences'
                    )
                    map(
                        event,
                        'gri',
                        vim.lsp.buf.implementation,
                        '[G]oto [I]mplementation'
                    )
                    map(
                        event,
                        'grd',
                        vim.lsp.buf.definition,
                        '[G]oto [D]efinition'
                    )
                    map(
                        event,
                        'grD',
                        vim.lsp.buf.declaration,
                        '[G]oto [D]eclaration'
                    )
                    map(
                        event,
                        'gO',
                        vim.lsp.buf.document_symbol,
                        'Open Document Symbols'
                    )
                    map(
                        event,
                        'gW',
                        vim.lsp.buf.workspace_symbol,
                        'Open Workspace Symbols'
                    )
                    map(
                        event,
                        'grt',
                        vim.lsp.buf.type_definition,
                        '[G]oto [T]ype Definition'
                    )

                    local client =
                        vim.lsp.get_client_by_id(event.data.client_id)
                    setup_document_highlight(client, event)

                    if
                        client
                        and client:supports_method(
                            vim.lsp.protocol.Methods.textDocument_inlayHint,
                            event.buf
                        )
                    then
                        map(event, '<leader>th', function()
                            vim.lsp.inlay_hint.enable(
                                not vim.lsp.inlay_hint.is_enabled {
                                    bufnr = event.buf,
                                }
                            )
                        end, '[T]oggle Inlay [H]ints')
                    end
                end,
            })

            vim.diagnostic.config {
                severity_sort = true,
                float = { border = 'rounded', source = 'if_many' },
                signs = vim.g.have_nerd_font
                        and {
                            text = {
                                [vim.diagnostic.severity.ERROR] = '󰅚 ',
                                [vim.diagnostic.severity.WARN] = '󰀪 ',
                                [vim.diagnostic.severity.INFO] = '󰋽 ',
                                [vim.diagnostic.severity.HINT] = '󰌶 ',
                            },
                        }
                    or {},
                virtual_text = {
                    source = 'if_many',
                },
            }

            local capabilities = require('blink.cmp').get_lsp_capabilities()

            local servers = {
                lua_ls = {
                    bin = 'lua-language-server',
                    on_init = function(client)
                        client.server_capabilities.documentFormattingProvider =
                            false -- Disable formatting (formatting is done by stylua)
                    end,
                    ---@type lspconfig.settings.lua_ls
                    settings = {
                        Lua = {
                            format = { enable = false }, -- Disable formatting (formatting is done by stylua)
                        },
                    },
                },
                nixd = { bin = 'nixd' },
                pyright = { bin = 'pyright-langserver' },
                ruff = { bin = 'ruff' },
                gopls = { bin = 'gopls' },
                rust_analyzer = { bin = 'rust-analyzer' },
                ts_ls = { bin = 'typescript-language-server' },
                bashls = { bin = 'bash-language-server' },
                biome = { bin = 'biome' },
                texlab = { bin = 'texlab' },
                marksman = { bin = 'marksman' },
            }

            local ensure_mason_install = {}

            for name, config in pairs(servers) do
                local bin_name = config.bin or name
                config.bin = nil -- Clean up custom metadata field

                -- If the binary is missing on $PATH, let Mason install it
                if vim.fn.executable(bin_name) == 0 then
                    table.insert(ensure_mason_install, name)
                end

                config.capabilities = vim.tbl_deep_extend(
                    'force',
                    {},
                    capabilities,
                    config.capabilities or {}
                )
                vim.lsp.config(name, config)
                vim.lsp.enable(name)
            end

            require('mason-lspconfig').setup {
                ensure_installed = ensure_mason_install,
            }

        end,
    },

    { -- Autoformat
        'stevearc/conform.nvim',
        cmd = { 'ConformInfo' },
        keys = {
            {
                '<leader>f',
                function()
                    require('conform').format {
                        async = true,
                    }
                end,
                mode = '',
                desc = '[F]ormat buffer',
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { 'stylua' },
                python = { 'ruff_fix', 'ruff_format' },
                go = { 'goimports', 'gofmt' },
                rust = { 'rustfmt' },
                nix = { 'alejandra' },
                bash = { 'shfmt' },
                sh = { 'shfmt' },
                elixir = { 'mix' },
                latex = { 'tex-fmt' },
                javascript = { 'biome' },
                typescript = { 'biome' },
                json = { 'biome' },
            },

            notify_on_error = false,
            format_on_save = {
                timeout_ms = 500,
                lsp_format = 'fallback',
            },
            default_format_opts = {
                timeout_ms = 500,
                lsp_format = 'fallback',
            },
        },
    },
    { -- Autocompletion
        'saghen/blink.cmp',
        event = 'VimEnter',
        version = '1.*',
        dependencies = {
            {
                'L3MON4D3/LuaSnip',
                version = 'v2.*',
                build = 'make install_jsregexp',
                dependencies = {
                    {
                        'rafamadriz/friendly-snippets',
                        config = function()
                            require('luasnip.loaders.from_vscode').lazy_load()
                        end,
                    },
                },
            },
        },
        opts = {
            keymap = {
                preset = 'default',
                ['<Tab>'] = {},
                ['<S-Tab>'] = {},
            },
            appearance = {
                nerd_font_variant = 'mono',
            },
            completion = {
                documentation = { auto_show = true, auto_show_delay_ms = 500 },
            },
            snippets = {
                preset = 'luasnip',
            },
            sources = {
                default = {
                    'lazydev',
                    'lsp',
                    'path',
                    'snippets',
                    'buffer',
                },
                providers = {
                    lazydev = {
                        name = 'LazyDev',
                        module = 'lazydev.integrations.blink',
                        score_offset = 100,
                    },
                },
            },
            fuzzy = { implementation = 'prefer_rust_with_warning' },
            signature = { enabled = true },
        },
    },
}
