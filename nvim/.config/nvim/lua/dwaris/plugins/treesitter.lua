return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        main = 'nvim-treesitter.configs',
        opts = {
            ensure_installed = {
                'bash',
                'c',
                'go',
                'json',
                'lua',
                'markdown',
                'markdown_inline',
                'nix',
                'python',
                'rust',
                'toml',
                'yaml',
            },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        },
    },
}
