if vim.g.vscode then
    vim.g.mapleader = ' '

    vim.opt.clipboard = 'unnamedplus'
    vim.opt.ignorecase = true
    vim.opt.smartcase = true
    vim.opt.incsearch = true

    vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

    local vscode = require 'vscode'

    vim.keymap.set({ 'n', 'x' }, '<leader>f', function()
        vscode.action 'editor.action.formatDocument'
    end, { desc = 'Format Document' })

    vim.keymap.set({ 'n', 'x' }, 'gra', function()
        vscode.action 'editor.action.codeAction'
    end, { desc = 'Code Action' })
    vim.keymap.set('n', 'grn', function()
        vscode.action 'editor.action.rename'
    end, { desc = 'Rename Symbol' })

    vim.keymap.set('n', '<leader>sf', function()
        vscode.action 'workbench.action.quickOpen'
    end, { desc = 'Search Files' })
    vim.keymap.set('n', '<leader>sg', function()
        vscode.action 'workbench.action.findInFiles'
    end, { desc = 'Search by Grep' })
    vim.keymap.set('n', '<leader><leader>', function()
        vscode.action 'workbench.action.showAllEditorsByMostRecentlyUsed'
    end, { desc = 'Find Buffers' })
    vim.keymap.set('n', '<leader>e', function()
        vscode.action 'workbench.view.explorer'
    end, { desc = 'Focus Explorer' })

    vim.keymap.set('n', '<leader>wh', function()
        vscode.action 'workbench.action.navigateLeft'
    end, { desc = 'Window Left' })
    vim.keymap.set('n', '<leader>wl', function()
        vscode.action 'workbench.action.navigateRight'
    end, { desc = 'Window Right' })
    vim.keymap.set('n', '<leader>wj', function()
        vscode.action 'workbench.action.navigateDown'
    end, { desc = 'Window Down' })
    vim.keymap.set('n', '<leader>wk', function()
        vscode.action 'workbench.action.navigateUp'
    end, { desc = 'Window Up' })
    vim.keymap.set('n', '<leader>wv', function()
        vscode.action 'workbench.action.splitEditorRight'
    end, { desc = 'Split Vertical' })
    vim.keymap.set('n', '<leader>ws', function()
        vscode.action 'workbench.action.splitEditorDown'
    end, { desc = 'Split Horizontal' })
    vim.keymap.set('n', '<leader>wc', function()
        vscode.action 'workbench.action.closeActiveEditor'
    end, { desc = 'Close Editor' })
    vim.keymap.set('n', '<leader>wo', function()
        vscode.action 'workbench.action.closeOtherEditors'
    end, { desc = 'Close Other Editors' })

    vim.keymap.set('n', '[d', function()
        vscode.action 'editor.action.marker.prev'
    end, { desc = 'Previous Diagnostic' })
    vim.keymap.set('n', ']d', function()
        vscode.action 'editor.action.marker.next'
    end, { desc = 'Next Diagnostic' })
    vim.keymap.set('n', '<leader>q', function()
        vscode.action 'workbench.actions.view.problems'
    end, { desc = 'Problems Quickfix' })
else
    require 'dwaris'
end
