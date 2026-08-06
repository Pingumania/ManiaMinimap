local _, ns = ...

local LSM = LibStub("LibSharedMedia-3.0")

ns:RegisterSettings("ManiaMinimapDB", {
	{
		key = "coords",
		type = "toggle",
		title = "Show coordinates",
		tooltip = "Draw your current position below the minimap.",
		default = true,
	},
	{
		type = "custom",
		title = "Coordinate font",
		tooltip = "The font the coordinates are drawn with.",
		requires = "coords",
		createControl = function(rowFrame)
			return ns:CreateMediaDropdown(rowFrame, "font", function()
				return ns:GetCoordsFont()
			end, function(name)
				ManiaMinimapDB.coordsFont = name
				ns:ApplyCoordsFont()
			end)
		end,
		onDefaults = function()
			ManiaMinimapDB.coordsFont = LSM:GetDefault("font")
			ns:ApplyCoordsFont()
		end,
	},
	{
		key = "coordsFontSize",
		type = "slider",
		title = "Coordinate font size",
		default = 11,
		minValue = 8,
		maxValue = 24,
		requires = "coords",
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

ns:RegisterSettingsSlash("/maniaminimap")
