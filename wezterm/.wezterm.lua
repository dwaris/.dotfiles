local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

config.enable_wayland = true
config.disable_default_key_bindings = true

config.color_scheme = "Catppuccin Mocha"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

config.scrollback_lines = 1000000
config.hyperlink_rules = wezterm.default_hyperlink_rules()
config.window_close_confirmation = "NeverPrompt"

config.font = wezterm.font("BlexMono Nerd Font")

config.leader = { key = "f", mods = "CTRL" }

config.unix_domains = {
	{
		name = "unix",
	},
}
config.default_gui_startup_args = { "connect", "unix" }

config.keys = {
	{ key = "c",     mods = "CTRL|SHIFT",   action = act.CopyTo("Clipboard") },
	{ key = "v",     mods = "CTRL|SHIFT",   action = act.PasteFrom("Clipboard") },
	{ key = "+",     mods = "CTRL|SHIFT",   action = act.IncreaseFontSize },
	{ key = "-",     mods = "CTRL|SHIFT",   action = act.DecreaseFontSize },
	{ key = "0",     mods = "CTRL|SHIFT",   action = act.ResetFontSize },

	{ key = "v",     mods = "LEADER",       action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "s",     mods = "LEADER",       action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

	{ key = "H",     mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 10 }) },
	{ key = "J",     mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 10 }) },
	{ key = "K",     mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 10 }) },
	{ key = "L",     mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 10 }) },

	{ key = "w",     mods = "LEADER",       action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{ key = "a",     mods = "LEADER",       action = act.AttachDomain("unix") },
	{ key = "d",     mods = "LEADER",       action = act.DetachDomain({ DomainName = "unix" }) },

	{ key = "q",     mods = "LEADER",       action = act.CloseCurrentPane({ confirm = false }) },
	{ key = "m",     mods = "LEADER",       action = act.TogglePaneZoomState },
	{ key = "0",     mods = "LEADER",       action = act.PaneSelect({ mode = "SwapWithActive" }) },

	{ key = "c",     mods = "LEADER",       action = act.SpawnTab("DefaultDomain") },
	{ key = "n",     mods = "LEADER",       action = act.ActivateTabRelative(1) },
	{ key = "p",     mods = "LEADER",       action = act.ActivateTabRelative(-1) },

	{ key = "h",     mods = "LEADER",       action = act.ActivatePaneDirection("Left") },
	{ key = "l",     mods = "LEADER",       action = act.ActivatePaneDirection("Right") },
	{ key = "k",     mods = "LEADER",       action = act.ActivatePaneDirection("Up") },
	{ key = "j",     mods = "LEADER",       action = act.ActivatePaneDirection("Down") },

	{ key = "Enter", mods = "LEADER",       action = act.ActivateCopyMode },
}

config.mouse_bindings = {
	{
		event  = { Up = { streak = 1, button = "Left" } },
		mods   = "NONE",
		action = act.DisableDefaultAssignment,
	},
	{
		event  = { Up = { streak = 1, button = "Left" } },
		mods   = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
	{
		event  = { Down = { streak = 1, button = "Left" } },
		mods   = "CTRL",
		action = act.Nop,
	},
}

for i = 1, 8 do
	table.insert(config.keys, {
		key    = tostring(i),
		mods   = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

return config