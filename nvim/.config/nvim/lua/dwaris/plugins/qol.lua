return {
    {
        'echasnovski/mini.icons',
        lazy = false,
        priority = 1000,
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {
            indent = {
                char = '│',
            },
            scope = {
                enabled = false,
            },
        },
    },
    {
        'j-hui/fidget.nvim',
        event = 'LspAttach',
        opts = {
            notification = {
                override_vim_notify = true,
            },
        },
    },
    {
        'stevearc/oil.nvim',
        lazy = false,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            default_file_explorer = true,
            view_options = {
                show_hidden = true,
            },
        },
        keys = {
            {
                '<leader>e',
                function()
                    require('oil').toggle_float()
                end,
                desc = 'Open Oil',
            },
        },
    },
}
