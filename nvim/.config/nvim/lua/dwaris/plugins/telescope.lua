return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('telescope').setup {
            pcall(require('telescope').load_extension, 'fzf'),
        }

        local builtin = require 'telescope.builtin'

        vim.keymap.set(
            'n',
            '<C-p>',
            builtin.git_files,
            { desc = '[S]earch [G]it [F]iles' }
        )

        vim.keymap.set(
            'n',
            '<leader>sk',
            builtin.keymaps,
            { desc = '[S]earch [K]eymaps' }
        )
        vim.keymap.set(
            'n',
            '<leader>sf',
            builtin.find_files,
            { desc = '[S]earch [F]iles' }
        )

        vim.keymap.set(
            'n',
            '<leader>sg',
            builtin.live_grep,
            { desc = '[S]earch by [G]rep' }
        )

        vim.keymap.set(
            'n',
            '<leader>sd',
            builtin.diagnostics,
            { desc = '[S]earch [D]iagnostics' }
        )

        vim.keymap.set('n', '<leader><leader>', function()
            builtin.find_files {
                search_dirs = { vim.fn.expand '%:p:h' },
            }
        end, { desc = '[S]earch [F]iles in current directory' })

        vim.keymap.set('n', '<leader>sn', function()
            builtin.find_files { cwd = vim.fn.stdpath 'config' }
        end, { desc = '[S]earch [N]eovim files' })
    end,
}
