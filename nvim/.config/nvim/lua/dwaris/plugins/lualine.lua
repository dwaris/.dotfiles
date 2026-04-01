local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand '%:t') ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
}

local config = {
    options = {
        component_separators = '',
        section_separators = '',
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
    color = { gui = 'bold' },
}

ins_left { 'progress', color = { gui = 'bold' } }

ins_left { 'location' }

ins_left {
    'diagnostics',
    sources = { 'nvim_diagnostic' },
}

ins_left {
    'branch',
    color = { gui = 'bold' },
}

ins_left {
    'diff',
    symbols = { added = '+', modified = '~', removed = '-' },
    cond = conditions.hide_in_width,
}

ins_right {
    function()
        local msg = 'No Active Lsp'
        local buf_ft = vim.api.nvim_get_option_value('filetype', {})
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
    color = { gui = 'bold' },
}

ins_right {
    'o:encoding',
    fmt = string.upper,
    cond = conditions.hide_in_width,
    color = { gui = 'bold' },
}

ins_right {
    'fileformat',
    fmt = string.upper,
    icons_enabled = false,
    color = { gui = 'bold' },
}

return {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    config = function()
        require('lualine').setup(config)
    end,
}
