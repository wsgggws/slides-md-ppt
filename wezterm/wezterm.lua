-- config.color_scheme = "Dracula (Official)"
-- config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = "Solarized (dark) (terminal.sexy)"
-- config.color_scheme = "tokyonight_night"
-- config.color_scheme = "Catppuccin Latte"
-- config.color_scheme = "Gruvbox light, soft (base16)"
-- config.colors = {
-- 	background = "#EBDBB2",
-- }
-- config.default_cursor_style = "BlinkingUnderline"
-- config.font = wezterm.font_with_fallback({ "JetBrains Mono", "Fira Code", "Noto Sans Mono CJK SC" })

local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder and wezterm.config_builder() or {}
config.color_scheme = "Dracula (Official)"
config.font_size = 20 -- 为了演示字体设置大了些，编写代码一般17
config.font = wezterm.font("comic mono")
config.window_decorations = "RESIZE"
config.default_cursor_style = "BlinkingBar"
config.hide_tab_bar_if_only_one_tab = true
config.scrollback_lines = 30000
config.window_padding = { top = 10, bottom = -10 }
config.tab_bar_at_bottom = true
config.window_close_confirmation = "NeverPrompt"
config.key_tables = {
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
	},
}
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1500 }
config.keys = {
	{ key = "L", mods = "CTRL", action = act.DisableDefaultAssignment },
	{ key = "H", mods = "CTRL", action = act.DisableDefaultAssignment },
	{ key = "D", mods = "CTRL", action = "ShowDebugOverlay" },
	{ key = "|", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "_", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
	{ key = "s", mods = "LEADER", action = act.PaneSelect({ mode = "SwapWithActive" }) },
	{ key = "b", mods = "LEADER", action = act.PaneSelect },
	{ key = " ", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
}

return config
