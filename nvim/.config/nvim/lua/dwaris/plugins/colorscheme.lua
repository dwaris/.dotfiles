return {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    auto_integrations = true,
    config = function()
        vim.cmd.colorscheme 'catppuccin'
    end,
}
