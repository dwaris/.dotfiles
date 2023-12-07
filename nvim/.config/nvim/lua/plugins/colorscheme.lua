return {
    'catppuccin/nvim',
    lazy = true,
    name = 'catppuccin',
    opts = {
        integrations = {
            cmp = true,
            dashboard = true,
            gitsigns = true,
            headlines = true,
            illuminate = true,
            indent_blankline = { enabled = true },
            lsp_trouboule = true,
            mason = true,
            markdown = true,
            mini = true,
            native_lsp = {
                enabled = true,
                underlines = {
                    errors = { 'undercurl' },
                    hints = { 'undercurl' },
                    warnings = { 'undercurl' },
                    information = { 'undercurl' },
                },
            },
            neotest = true,
            neotree = true,
            semantic_tokens = true,
            telescope = true,
            treesitter = true,
            treesitter_context = true,
            which_key = true,
        },
    },
    {
        'LazyVim/LazyVim',
        opts = {
            colorscheme = 'catppuccin-mocha',
        },
    },
}
