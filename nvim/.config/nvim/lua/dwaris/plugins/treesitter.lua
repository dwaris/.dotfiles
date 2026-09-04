return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        local ts = require 'nvim-treesitter'

        ts.setup {
            install_dir = vim.fn.stdpath 'data' .. '/site',
        }

        ts.install {
            'bash',
            'c',
            'cpp',
            'go',
            'html',
            'javascript',
            'json',
            'lua',
            'luadoc',
            'markdown',
            'markdown_inline',
            'nix',
            'python',
            'query',
            'rust',
            'typescript',
            'vue',
            'yaml',
        }

        -- Automatically start Treesitter highlighting on supported buffers
        vim.api.nvim_create_autocmd('FileType', {
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })
    end,
}
