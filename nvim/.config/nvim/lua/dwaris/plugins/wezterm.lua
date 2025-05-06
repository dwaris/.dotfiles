return {
    'mrjones2014/smart-splits.nvim',
    lazy = false,
    keys = {
        { '<C-h>', ':SmartCursorMoveLeft<CR>', silent = true },
        { '<C-j>', ':SmartCursorMoveDown<CR>', silent = true },
        { '<C-k>', ':SmartCursorMoveUp<CR>', silent = true },
        { '<C-l>', ':SmartCursorMoveRight<CR>', silent = true },
        { '<A-Left>', ':SmartResizeLeft  5<CR>', silent = true },
        { '<A-Right>', ':SmartResizeRight 5<CR>', silent = true },
        { '<A-Up>', ':SmartResizeUp    5<CR>', silent = true },
        { '<A-Down>', ':SmartResizeDown  5<CR>', silent = true },
    },
}
