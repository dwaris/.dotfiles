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
    {
        'neovim/nvim-lspconfig',
        dependencies = {

            { 'mason-org/mason.nvim', opts = {} },
            'mason-org/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            { 'j-hui/fidget.nvim',    opts = {} },

            'saghen/blink.cmp',
        },

        config = function()
            local telescope = require 'telescope.builtin'

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup(
                    'kickstart-lsp-attach',
                    { clear = true }
                ),
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

                    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
                    map(
                        'gra',
                        vim.lsp.buf.code_action,
                        '[G]oto Code [A]ction',
                        { 'n', 'x' }
                    )
                    map(
                        'grr',
                        telescope.lsp_references,
                        '[G]oto [R]eferences'
                    )
                    map(
                        'gri',
                        telescope.lsp_implementations,
                        '[G]oto [I]mplementation'
                    )
                    map(
                        'grd',
                        telescope.lsp_definitions,
                        '[G]oto [D]efinition'
                    )
                    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                    map(
                        'gO',
                        telescope.lsp_document_symbols,
                        'Open Document Symbols'
                    )
                    map(
                        'gW',
                        telescope.lsp_dynamic_workspace_symbols,
                        'Open Workspace Symbols'
                    )
                    map(
                        'grt',
                        telescope.lsp_type_definitions,
                        '[G]oto [T]ype Definition'
                    )

                    local client =
                        vim.lsp.get_client_by_id(event.data.client_id)
                    if
                        client
                        and client:supports_method(
                            vim.lsp.protocol.Methods.textDocument_documentHighlight,
                            event.buf
                        )
                    then
                        local highlight_augroup = vim.api.nvim_create_augroup(
                            'kickstart-lsp-highlight',
                            { clear = false }
                        )
                        vim.api.nvim_create_autocmd(
                            { 'CursorHold', 'CursorHoldI' },
                            {
                                buffer = event.buf,
                                group = highlight_augroup,
                                callback = vim.lsp.buf.document_highlight,
                            }
                        )

                        vim.api.nvim_create_autocmd(
                            { 'CursorMoved', 'CursorMovedI' },
                            {
                                buffer = event.buf,
                                group = highlight_augroup,
                                callback = vim.lsp.buf.clear_references,
                            }
                        )

                        vim.api.nvim_create_autocmd('LspDetach', {
                            group = vim.api.nvim_create_augroup(
                                'kickstart-lsp-detach',
                                { clear = true }
                            ),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds {
                                    group = 'kickstart-lsp-highlight',
                                    buffer = event2.buf,
                                }
                            end,
                        })
                    end

                    if
                        client
                        and client:supports_method(
                            vim.lsp.protocol.Methods.textDocument_inlayHint,
                            event.buf
                        )
                    then
                        map('<leader>th', function()
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

            local servers = {}
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                'stylua', -- Used to format Lua code
            })

            require('mason-tool-installer').setup {
                ensure_installed = ensure_installed,
            }

            require('mason-lspconfig').setup {
                -- Install management is handled by mason-tool-installer.
                ensure_installed = {},
                automatic_installation = false,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend(
                            'force',
                            {},
                            capabilities,
                            server.capabilities or {}
                        )
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            }
        end,
    },

    { -- Autoformat
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
        keys = {
            {
                '<leader>f',
                function()
                    require('conform').format {
                        async = true,
                        lsp_format = 'fallback',
                    }
                end,
                mode = '',
                desc = '[F]ormat buffer',
            },
        },
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. You can add additional
                -- languages here or re-enable it for the disabled ones.
                local disable_filetypes = { c = true, cpp = true }
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    return nil
                else
                    return {
                        timeout_ms = 500,
                        lsp_format = 'fallback',
                    }
                end
            end,
            formatters_by_ft = {
                lua = { 'stylua' },
                python = { 'black' },
                go = { 'gofmt' },
                rust = { 'rustfmt' },
                nix = { 'alejandra' },
                latex = { 'tex-fmt' },
                javascript = { 'prettierd' },
                typescript = { 'prettierd' },
                elixir = { "mix" },
            },
        },
    },
    { -- Autocompletion
        'saghen/blink.cmp',
        event = 'VimEnter',
        version = '1.*',
        dependencies = {
            -- Snippet Engine
            {
                'L3MON4D3/LuaSnip',
                version = '2.*',
                build = (function()
                    -- Build Step is needed for regex support in snippets.
                    -- This step is not supported in many windows environments.
                    -- Remove the below condition to re-enable on windows.
                    if
                        vim.fn.has 'win32' == 1
                        or vim.fn.executable 'make' == 0
                    then
                        return
                    end
                    return 'make install_jsregexp'
                end)(),
                dependencies = {
                    {
                        'rafamadriz/friendly-snippets',
                        config = function()
                            require('luasnip.loaders.from_vscode').lazy_load()
                        end,
                    },
                },
                opts = {},
            },
            'folke/lazydev.nvim',
        },
        --- @module 'blink.cmp'
        --- @type blink.cmp.Config
        opts = {
            keymap = {
                preset = 'default',
            },

            appearance = {
                nerd_font_variant = 'mono',
            },

            completion = {
                documentation = { auto_show = true, auto_show_delay_ms = 500 },
            },

            sources = {
                default = {
                    'buffer',
                    'lsp',
                    'omni',
                    'lazydev',
                    'path',
                },
                providers = {
                    lazydev = {
                        module = 'lazydev.integrations.blink',
                        score_offset = 100,
                    },
                },
            },

            snippets = { preset = 'luasnip' },

            -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
            -- which automatically downloads a prebuilt binary when enabled.
            --
            -- By default, we use the Lua implementation instead, but you may enable
            -- the rust implementation via `'prefer_rust_with_warning'`
            --
            -- See :h blink-cmp-config-fuzzy for more information
            fuzzy = { implementation = 'rust' },

            signature = { enabled = true },
        },
    },
}
