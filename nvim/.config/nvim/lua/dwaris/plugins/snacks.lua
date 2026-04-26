return {
    {
        'echasnovski/mini.icons',
        lazy = false,
        priority = 1000,
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
            lazygit = { enabled = true },
            indent = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            words = { enabled = true },
        },
        keys = {
            {
                '<leader>n',
                function()
                    Snacks.notifier.show_history()
                end,
                desc = 'Notification History',
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
                '<leader>un',
                function()
                    Snacks.notifier.hide()
                end,
                desc = 'Dismiss All Notifications',
            },
            {
                '<leader>fp',
                function()
                    Snacks.picker.projects()
                end,
                desc = 'Find Projects',
            },
        },
    }
}
