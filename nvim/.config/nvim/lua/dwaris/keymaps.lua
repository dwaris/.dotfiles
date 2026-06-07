vim.g.mapleader = ' '

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Window navigation
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = '[W]indow [H] left' })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = '[W]indow [J] down' })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = '[W]indow [K] up' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = '[W]indow [L] right' })
vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = '[W]indow split [V]ertical' })
vim.keymap.set('n', '<leader>ws', '<C-w>s', { desc = '[W]indow split [S]horizontal' })
vim.keymap.set('n', '<leader>wc', '<C-w>c', { desc = '[W]indow [C]lose' })
vim.keymap.set('n', '<leader>wo', '<C-w>o', { desc = '[W]indow [O]nly' })
