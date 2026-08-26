return {
    'stevearc/oil.nvim',
    lazy = false,
    opts = {
        default_file_explorer = true,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        keymaps = {
            ['q'] = 'actions.close',
        },
        view_options = {
            show_hidden = true,
            natural_order = true,
            is_always_hidden = function(name, _)
                return name == '..' or name == '.git'
            end,
        },
    },
    keys = {
        { '-', '<cmd>Oil<cr>', desc = 'Open Parent Directory (Oil)' },
        { '<leader>e', '<cmd>Oil<cr>', desc = 'File Explorer (Oil)' },
    },
}
