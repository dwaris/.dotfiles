local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

config.enable_wayland = true
config.disable_default_key_bindings = true

config.color_scheme = "Catppuccin Mocha"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

config.scrollback_lines = 100000
config.hyperlink_rules = wezterm.default_hyperlink_rules()
config.window_close_confirmation = "NeverPrompt"

config.font = wezterm.font_with_fallback({
	"Sauce Code Pro Nerd Font",
	"Source Code Pro",
})

config.leader = { key = "f", mods = "CTRL" }

config.unix_domains = {
	{
		name = "unix",
	},
}
config.default_gui_startup_args = { "connect", "unix" }

config.keys = {
	{ key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
	{ key = "+", mods = "CTRL|SHIFT", action = act.IncreaseFontSize },
	{ key = "-", mods = "CTRL|SHIFT", action = act.DecreaseFontSize },
	{ key = "0", mods = "CTRL|SHIFT", action = act.ResetFontSize },

	{
		mods = "LEADER",
		key = "-",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "=",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "q",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	{
		mods = "LEADER",
		key = "m",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		mods = "LEADER",
		key = "0",
		action = wezterm.action.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
	{
		mods = "LEADER",
		key = "c",
		action = wezterm.action.SpawnTab("DefaultDomain"),
	},
	{
		mods = "LEADER",
		key = "n",
		action = act.ActivateTabRelative(1),
	},
	{
		mods = "LEADER",
		key = "p",
		action = act.ActivateTabRelative(-1),
	},

	{ mods = "LEADER", key = "h", action = act.ActivatePaneDirection("Left") },
	{ mods = "LEADER", key = "l", action = act.ActivatePaneDirection("Right") },
	{ mods = "LEADER", key = "k", action = act.ActivatePaneDirection("Up") },
	{ mods = "LEADER", key = "j", action = act.ActivatePaneDirection("Down") },

	{
		key = "Enter",
		mods = "LEADER",
		action = wezterm.action.ActivateCopyMode,
	},
}

config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.DisableDefaultAssignment, -- You may want a different option here. See /u/Brian's comment below
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
	{
		event = { Down = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.Nop,
	},
}

for i = 1, 8 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

return config
