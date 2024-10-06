local colors = {
    bg       = '#1e1e2e',
    fg       = '#CDD6F4',
    yellow   = '#ECBE7B',
    cyan     = '#94e2d5',
    darkblue = '#081633',
    green    = '#98be65',
    orange   = '#FF8800',
    salmon   = '#f9e2af"',
    violet   = '#a9a1e1',
    magenta  = '#c678dd',
    blue     = '#51afef',
    red      = '#ec5f67',
}

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand '%:t') ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand '%:p:h'
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
}

-- Config
local config = {
    options = {
        -- Disable sections and component separators
        component_separators = '',
        section_separators = '',
        theme = {
            normal = {},
            inactive = {},

            insert = { a = { fg = colors.bg, bg = colors.cyan } },
            visual = { a = { fg = colors.bg, bg = colors.yellow } },
            replace = { a = { fg = colors.bg, bg = colors.red } },
        },
    },
    sections = {
        lualine_a = {
            { 'mode', separator = { left = '' }, right_padding = 2 },
        },
        lualine_b = {},

        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
    },
}

local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
end

local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
end

ins_left {
    'filename',
    cond = conditions.buffer_not_empty,
    color = { fg = colors.magenta, gui = 'bold' },
}

ins_left { 'progress', color = { fg = colors.fg, gui = 'bold' } }

ins_left { 'location' }

ins_left {
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    diagnostics_color = {
        color_error = { fg = colors.red },
        color_warn = { fg = colors.yellow },
        color_info = { fg = colors.cyan },
    },
}

ins_left {
    'branch',
    color = { fg = colors.violet, gui = 'bold' },
}

ins_left {
    'diff',
    symbols = { added = '+', modified = '~', removed = '-' },
    diff_color = {
        added = { fg = colors.green },
        modified = { fg = colors.orange },
        removed = { fg = colors.red },
    },
    cond = conditions.hide_in_width,
}

ins_right {
    function()
        local msg = 'No Active Lsp'
        local buf_ft = vim.api.nvim_get_option_value("filetype", {})
        local clients = vim.lsp.get_clients()
        if next(clients) == nil then
            return msg
        end
        for _, client in ipairs(clients) do
            ---@diagnostic disable-next-line: undefined-field
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
            end
        end
        return msg
    end,
    color = { fg = '#E4E4E4', gui = 'bold' },
}

ins_right {
    'o:encoding',       -- option component same as &encoding in viml
    fmt = string.upper, -- I'm not sure why it's upper case either ;)
    cond = conditions.hide_in_width,
    color = { fg = colors.salmon, gui = 'bold' },
}

ins_right {
    'fileformat',
    fmt = string.upper,
    icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
    color = { fg = colors.salmon, gui = 'bold' },
}

return {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    config = function()
        require('lualine').setup(config)
    end
}
