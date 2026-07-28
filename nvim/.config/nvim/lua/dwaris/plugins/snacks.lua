return {
    {
        'echasnovski/mini.icons',
        lazy = false,
        priority = 1000,
        opts = {},
        config = function(_, opts)
            local icons = require 'mini.icons'
            icons.setup(opts)
            icons.mock_nvim_web_devicons()
        end,
    },
    {
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = true },
            bufdelete = { enabled = true },
            dashboard = {
                enabled = true,
                sections = {
                    { section = 'header' },
                    { section = 'keys',   gap = 1, padding = 1 },
                    { section = 'startup' },
                    {
                        section = 'projects',
                        title = 'Projects',
                        padding = 1,
                    },
                    {
                        section = 'recent_files',
                        title = 'Recent Files',
                        padding = 1,
                    },
                },
            },
            explorer = { enabled = true },
            picker = { enabled = true },
            lazygit = { enabled = true },
            indent = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            words = { enabled = true },
        },
        keys = {
            {
                '<leader>e',
                function()
                    Snacks.explorer()
                end,
                desc = 'File Explorer',
            },
            {
                '<leader>nh',
                function()
                    Snacks.notifier.show_history()
                end,
                desc = 'Notification History',
            },
            {
                '<leader>nd',
                function()
                    Snacks.notifier.hide()
                end,
                desc = 'Dismiss All Notifications',
            },
            {
                '<leader>bd',
                function()
                    Snacks.bufdelete()
                end,
                desc = 'Delete Buffer',
            },
            {
                '<leader>cR',
                function()
                    Snacks.rename.rename_file()
                end,
                desc = 'Rename File',
            },
            {
                '<leader>gf',
                function()
                    Snacks.lazygit.log_file()
                end,
                desc = 'Lazygit Current File Log',
            },
            {
                '<leader>gg',
                function()
                    Snacks.lazygit()
                end,
                desc = 'Lazygit',
            },
            {
                '<leader>gl',
                function()
                    Snacks.lazygit.log()
                end,
                desc = 'Lazygit Log',
            },
            {
                '<leader>sp',
                function()
                    Snacks.picker.projects()
                end,
                desc = 'Search Projects',
            },
            {
                '<leader>sf',
                function()
                    Snacks.picker.files()
                end,
                desc = 'Search Files',
            },
            {
                '<leader>sg',
                function()
                    Snacks.picker.grep()
                end,
                desc = 'Search by Grep',
            },
            {
                '<leader>sw',
                function()
                    Snacks.picker.grep_word()
                end,
                desc = 'Search current Word',
            },
            {
                '<leader>sh',
                function()
                    Snacks.picker.help()
                end,
                desc = 'Search Help',
            },
            {
                '<leader>sk',
                function()
                    Snacks.picker.keymaps()
                end,
                desc = 'Search Keymaps',
            },
            {
                '<leader>sd',
                function()
                    Snacks.picker.diagnostics()
                end,
                desc = 'Search Diagnostics',
            },
            {
                '<leader>sr',
                function()
                    Snacks.picker.resume()
                end,
                desc = 'Search Resume',
            },
            {
                '<leader>s.',
                function()
                    Snacks.picker.recent()
                end,
                desc = 'Search Recent Files',
            },
            {
                '<leader><leader>',
                function()
                    Snacks.picker.buffers()
                end,
                desc = 'Find existing buffers',
            },
            {
                '<leader>/',
                function()
                    Snacks.picker.lines()
                end,
                desc = 'Search inside current buffer',
            },
            {
                '<leader>s/',
                function()
                    Snacks.picker.grep_buffers()
                end,
                desc = 'Search in Open Files',
            },
            {
                '<leader>sn',
                function()
                    Snacks.picker.files({ cwd = vim.fn.stdpath('config') })
                end,
                desc = 'Search Neovim config files',
            },
        },
    }
}
