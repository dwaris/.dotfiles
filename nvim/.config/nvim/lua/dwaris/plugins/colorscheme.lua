local omarchy_theme = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")

if vim.fn.filereadable(omarchy_theme) == 1 then
  return dofile(omarchy_theme)
else
    return {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
        auto_integrations = true,
        config = function()
            vim.cmd.colorscheme 'catppuccin-nvim'
        end,
    }
end
