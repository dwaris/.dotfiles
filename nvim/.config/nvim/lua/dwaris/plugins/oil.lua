return {
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
}