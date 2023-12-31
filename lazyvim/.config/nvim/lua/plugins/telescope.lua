return {
    {
        'telescope.nvim',
        opts = {
            defaults = {
                prompt_prefix = '> ',
                selection_caret = '>> ',
                border = {},
                borderchars = {
                    '─',
                    '│',
                    '─',
                    '│',
                    '┌',
                    '┐',
                    '┘',
                    '└',
                },
            },
        },
        dependencies = {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            config = function()
                require('telescope').load_extension 'fzf'
            end,
        },
    },
}
