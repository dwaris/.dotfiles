return {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    opts = {
        on_attach = function(bufnr)
            local gitsigns = package.loaded.gitsigns

            local function map(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, {
                    buffer = bufnr,
                    desc = desc,
                })
            end

            map('n', '<leader>gn', gitsigns.next_hunk, 'Git next hunk')
            map('n', '<leader>gp', gitsigns.prev_hunk, 'Git previous hunk')
            map('n', '<leader>gs', gitsigns.stage_hunk, 'Git stage hunk')
            map('n', '<leader>gr', gitsigns.reset_hunk, 'Git reset hunk')
            map('n', '<leader>gS', gitsigns.stage_buffer, 'Git stage buffer')
            map('n', '<leader>gu', gitsigns.undo_stage_hunk, 'Git undo stage hunk')
            map('n', '<leader>gP', gitsigns.preview_hunk, 'Git preview hunk')
            map('n', '<leader>gb', gitsigns.blame_line, 'Git blame line')
            map('n', '<leader>gd', gitsigns.diffthis, 'Git diff this')
        end,
    },
}
