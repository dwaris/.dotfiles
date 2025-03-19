return {
    'echasnovski/mini.nvim',
    config = function()
        -- Better Around/Inside textobjects
        require('mini.ai').setup { n_lines = 500 }

        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        require('mini.surround').setup()

        -- Smart commenting
        require('mini.comment').setup()

        -- Auto-closing pairs
        require('mini.pairs').setup()

        -- Move lines and selections
        require('mini.move').setup()
    end,
}
