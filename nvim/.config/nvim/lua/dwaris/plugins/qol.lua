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
}
