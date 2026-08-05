local _, A = ...

A:RegisterSettings("ManiaMinimapDB", {
	{
		key = "coords",
		type = "toggle",
		title = "Show coordinates",
		tooltip = "Draw your current position below the minimap.",
		default = true,
	},
	{
		key = "border",
		type = "toggle",
		title = "Custom border",
		tooltip = "Replace the default minimap border with the action bar border.",
		default = true,
	},
	{
		key = "hideZoomButtons",
		type = "toggle",
		title = "Hide the zoom buttons",
		default = true,
	},
	{
		key = "hideCalendar",
		type = "toggle",
		title = "Hide the calendar button",
		default = true,
	},
})

A:RegisterSettingsSlash("/maniaminimap")
