sed -i 's/^palette = .*/palette = "catppuccin_latte"/' ~/.config/starship/starship.toml
sed -i "s/\(vim.cmd.colorscheme \)'catppuccin'/\1'catppuccin-latte'/" ~/.config/nvim/lua/dwaris/plugins/theme.lua
