return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        branch = 'master',
        opts = {
            ensure_installed = {
                'bash',
                'c',
                'diff',
                'html',
                'json',
                'lua',
                'luadoc',
                'markdown',
                'markdown_inline',
                'nix',
                'toml',
                'vim',
                'vimdoc',
                'yaml',
            },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        },
    },
}
