return {
    'echasnovski/mini.statusline',
    event = 'VeryLazy',
    opts = function()
        return {
            content = {
                active = function()
                    local mode, mode_hl =
                        MiniStatusline.section_mode { trunc_width = 120 }
                    local git = MiniStatusline.section_git { trunc_width = 75 }
                    local diff = MiniStatusline.section_diff { trunc_width = 75 }
                    local diagnostics =
                        MiniStatusline.section_diagnostics { trunc_width = 75 }
                    local filename =
                        MiniStatusline.section_filename { trunc_width = 140 }
                    local location = '%l/%L'

                    local clients = vim.lsp.get_clients { bufnr = 0 }
                    local lsp = #clients > 0
                            and table.concat(
                                vim.tbl_map(function(c)
                                    return c.name
                                end, clients),
                                ', '
                            )
                        or ''

                    return MiniStatusline.combine_groups {
                        { hl = mode_hl, strings = { mode } },
                        {
                            hl = 'MiniStatuslineDevinfo',
                            strings = { git, diff, diagnostics },
                        },
                        '%<',
                        {
                            hl = 'MiniStatuslineFilename',
                            strings = { filename },
                        },
                        '%=',
                        { hl = 'MiniStatuslineFilename', strings = { lsp } },
                        { hl = 'MiniStatuslineDevinfo', strings = { location } },
                    }
                end,
            },
        }
    end,
}
