return {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
        spec = {
            { '<leader>s', group = '[S]earch' },
            { '<leader>t', group = '[T]oggle' },
            { '<leader>w', group = '[W]indow' },

            { '<leader>g', group = '[G]it' },
        },
    },
}
