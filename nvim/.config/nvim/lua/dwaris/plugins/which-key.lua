return {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
        spec = {
            { '<leader>s', group = '[S]earch' },
            { '<leader>t', group = '[T]oggle' },
            { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        },
    },
}
