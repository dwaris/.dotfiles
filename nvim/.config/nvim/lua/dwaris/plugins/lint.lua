return {
    {
        'mfussenegger/nvim-lint',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = lint.linters_by_ft or {}

            lint.linters_by_ft.go = { "golangcilint" }
            lint.linters_by_ft.markdown = { "markdownlint" }
            lint.linters_by_ft.lua = { "luacheck" }
            lint.linters_by_ft.python = { "pylint" }

            vim.api.nvim_create_autocmd(
                { "BufWritePost", "InsertLeave" },
                {
                    group = vim.api.nvim_create_augroup("lint", { clear = true }),
                    callback = function()
                        vim.defer_fn(function()
                            lint.try_lint()
                        end, 100)
                    end,
                }
            )
        end,
    },
}
