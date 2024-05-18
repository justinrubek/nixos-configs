local config = wezterm.config_builder()

config.enable_tab_bar = false
local opacity = 0.50
config.window_background_opacity = opacity
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

wezterm.on("toggle-opacity", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 1.0
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

wezterm.on("inc-opacity", function(window, pane)
	opacity = opacity + 0.12
	if opacity > 1.0 then
		opacity = 1.0
	end
	local overrides = window:get_config_overrides() or {}
	overrides.window_background_opacity = opacity
	window:set_config_overrides(overrides)
end)

wezterm.on("dec-opacity", function(window, pane)
	opacity = opacity - 0.12
	if opacity < 0.0 then
		opacity = 0.0
	end
	local overrides = window:get_config_overrides() or {}
	overrides.window_background_opacity = opacity
	window:set_config_overrides(overrides)
end)

config.keys = {
	{ key = "\r", mods = "CTRL", action = wezterm.action.SpawnWindow },
	{ key = "[", mods = "CTRL", action = wezterm.action.EmitEvent("dec-opacity") },
	{ key = "]", mods = "CTRL", action = wezterm.action.EmitEvent("inc-opacity") },
	{
		key = "O",
		mods = "CTRL",
		action = wezterm.action.EmitEvent("toggle-opacity"),
	},
}

return config
