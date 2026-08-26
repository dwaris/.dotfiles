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
        opts = {
            bigfile = { enabled = true },
            bufdelete = { enabled = true },
            dashboard = {
                enabled = true,
                sections = {
                    { section = 'header' },
                    { section = 'keys', gap = 1, padding = 1 },
                    { section = 'startup' },
                    { section = 'projects', title = 'Projects', padding = 1 },
                    {
                        section = 'recent_files',
                        title = 'Recent Files',
                        padding = 1,
                    },
                },
            },
            explorer = { enabled = false },
            image = { enabled = true },
            indent = { enabled = true },
            lazygit = { enabled = true },
            notifier = { enabled = true },
            picker = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scratch = { enabled = true },
            words = { enabled = true },
        },
        keys = {
            -- Scratchpad & Undo
            {
                '<leader>.',
                function()
                    Snacks.scratch()
                end,
                desc = 'Toggle Scratchpad',
            },
            {
                '<leader>S',
                function()
                    Snacks.scratch.select()
                end,
                desc = 'Select Scratchpad',
            },
            {
                '<leader>u',
                function()
                    Snacks.picker.undo()
                end,
                desc = 'Visual [U]ndo History',
            },

            -- Search Pickers
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
                desc = 'Search Word',
            },
            {
                '<leader>sp',
                function()
                    Snacks.picker.projects()
                end,
                desc = 'Search Projects',
            },
            {
                '<leader>s.',
                function()
                    Snacks.picker.recent()
                end,
                desc = 'Recent Files',
            },
            {
                '<leader>sd',
                function()
                    Snacks.picker.diagnostics()
                end,
                desc = 'Search Diagnostics',
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
                '<leader>sr',
                function()
                    Snacks.picker.resume()
                end,
                desc = 'Resume Search',
            },
            {
                '<leader><leader>',
                function()
                    Snacks.picker.buffers()
                end,
                desc = 'Find Buffers',
            },
            {
                '<leader>/',
                function()
                    Snacks.picker.lines()
                end,
                desc = 'Search Buffer Lines',
            },
            {
                '<leader>s/',
                function()
                    Snacks.picker.grep_buffers()
                end,
                desc = 'Search Open Files',
            },
            {
                '<leader>sn',
                function()
                    Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
                end,
                desc = 'Search Neovim Config',
            },

            -- Toggles
            {
                '<leader>td',
                function()
                    Snacks.toggle.diagnostics():toggle()
                end,
                desc = 'Toggle Diagnostics',
            },
            {
                '<leader>th',
                function()
                    Snacks.toggle.inlay_hints():toggle()
                end,
                desc = 'Toggle Inlay Hints',
            },
            {
                '<leader>tl',
                function()
                    Snacks.toggle.line_number():toggle()
                end,
                desc = 'Toggle Line Numbers',
            },
            {
                '<leader>tw',
                function()
                    Snacks.toggle.option('wrap', { name = 'Wrap' }):toggle()
                end,
                desc = 'Toggle Wrap',
            },
            {
                '<leader>ts',
                function()
                    Snacks.toggle
                        .option('spell', { name = 'Spelling' })
                        :toggle()
                end,
                desc = 'Toggle Spelling',
            },

            -- Git
            {
                '<leader>gg',
                function()
                    Snacks.lazygit()
                end,
                desc = 'Lazygit',
            },
            {
                '<leader>gf',
                function()
                    Snacks.lazygit.log_file()
                end,
                desc = 'Lazygit File Log',
            },
            {
                '<leader>gl',
                function()
                    Snacks.lazygit.log()
                end,
                desc = 'Lazygit Log',
            },

            -- Utilities
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
                desc = 'Dismiss Notifications',
            },
        },
    },
}
