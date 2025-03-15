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
            { 'j-hui/fidget.nvim', opts = {} },
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
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

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-t>.
                    map(
                        'gd',
                        require('telescope.builtin').lsp_definitions,
                        '[G]oto [D]efinition'
                    )

                    -- Find references for the word under your cursor.
                    map(
                        'gr',
                        require('telescope.builtin').lsp_references,
                        '[G]oto [R]eferences'
                    )

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map(
                        'gI',
                        require('telescope.builtin').lsp_implementations,
                        '[G]oto [I]mplementation'
                    )

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    map(
                        '<leader>D',
                        require('telescope.builtin').lsp_type_definitions,
                        'Type [D]efinition'
                    )

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map(
                        '<leader>ds',
                        require('telescope.builtin').lsp_document_symbols,
                        '[D]ocument [S]ymbols'
                    )

                    -- Fuzzy find all the symbols in your current workspace.
                    --  Similar to document symbols, except searches over your entire project.
                    map(
                        '<leader>ws',
                        require('telescope.builtin').lsp_dynamic_workspace_symbols,
                        '[W]orkspace [S]ymbols'
                    )

                    -- Rename the variable under your cursor.
                    --  Most Language Servers support renaming across files, etc.
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map(
                        '<leader>ca',
                        vim.lsp.buf.code_action,
                        '[C]ode [A]ction',
                        { 'n', 'x' }
                    )

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                end,
            })

            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            local lspconfig = require 'lspconfig'
            local function setup_server(server, config)
                if not lspconfig[server] then
                    vim.notify("LSP-Server " .. server .. " not found!", vim.log.levels.WARN)
                    return
                end
                lspconfig[server].setup(config or {})
            end

            setup_server("rust_analyzer", {
                settings = {
                    ["rust-analyzer"] = { checkOnSave = { command = "clippy" } },
                },
            })
            setup_server("gopls", {})
            setup_server("pyright", {})
            setup_server("marksman", {})
            setup_server("bashls", {})
            setup_server("lua_ls", {
                settings = { Lua = { completion = { callSnippet = "Replace" } } },
            })
            setup_server("nil_ls", {
                settings = {
                    ["nil"] = {
                        formatting = { command = { "alejandra" } },
                        nix = { flake = { autoArchive = false } },
                    },
                },
            })
        end,
    },
}
