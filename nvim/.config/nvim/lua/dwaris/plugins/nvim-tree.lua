return {
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFindFile' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
        {
            '<leader>e',
            '<cmd>NvimTreeToggle<cr>',
            desc = '[E]xplorer (Nvim-tree)',
        },
    },
    opts = {
        actions = {
            open_file = { quit_on_open = false },
        },
        filters = {
            dotfiles = false,
            custom = { '^\\.direnv', '^\\.git' },
        },
        view = {
            width = 35,
            side = 'left',
        },
    },
    config = function(_, opts)
        require('nvim-tree').setup(opts)
        local api = require('nvim-tree.api')
        api.events.subscribe(api.events.Event.TreeOpen, function()
            api.tree.expand_all()
        end)
    end,
}
