return {
    {
        'chomosuke/typst-preview.nvim',
        ft = 'typst',
        version = '1.*',
        opts = {
            dependencies_bin = {
                ['tinymist'] = 'tinymist',
                ['websocat'] = 'websocat',
            },
        },
        keys = {
            {
                '<leader>tp',
                '<cmd>TypstPreviewToggle<cr>',
                ft = 'typst',
                desc = 'Toggle [T]ypst [P]review',
            },
        },
    },
    {
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
            default = {
                dir_path = 'assets',
                prompt_for_file_name = false,
                drag_and_drop = {
                    insert_mode = true,
                },
            },
        },
        keys = {
            {
                '<leader>p',
                '<cmd>PasteImage<cr>',
                ft = { 'markdown', 'typst', 'tex' },
                desc = '[P]aste Image from Clipboard',
            },
        },
    },
}
