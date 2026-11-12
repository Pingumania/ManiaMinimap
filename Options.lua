local _, ns = ...

local LSM = LibStub("LibSharedMedia-3.0")

local settings = {
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
		key = "coordsOffsetX",
		type = "slider",
		title = "Coordinate offset X",
		tooltip = "Horizontal position of the coordinates, from the minimap's bottom right corner.",
		default = -5,
		minValue = -100,
		maxValue = 100,
		requires = "coords",
	},
	{
		key = "coordsOffsetY",
		type = "slider",
		title = "Coordinate offset Y",
		tooltip = "Vertical position of the coordinates, from the minimap's bottom right corner.",
		default = -9,
		minValue = -100,
		maxValue = 100,
		requires = "coords",
	},
	{
		key = "mapSize",
		type = "slider",
		title = "Minimap size",
		tooltip = "Width and height of the minimap.",
		default = 236,
		minValue = 140,
		maxValue = 400,
	},
	{
		key = "headerFontSize",
		type = "slider",
		title = "Header font size",
		tooltip = "Font size of the zone text, clock and addon compartment.",
		default = 11,
		minValue = 8,
		maxValue = 18,
		valueStep = 0.5,
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
	{
		key = "hideDayNight",
		type = "toggle",
		title = "Hide the day/night indicator",
		default = false,
		hidden = not MinimapCluster.DielFrame,
	},
}

ns:RegisterSettings("ManiaMinimapDB", settings)
ns:RegisterSettingsSlash("/maniaminimap")

local LibEditMode = ns.LibEditMode
local SETTING_KINDS = {
	toggle = LibEditMode.SettingType.Checkbox,
	slider = LibEditMode.SettingType.Slider,
}

local editModeSettings = {}
for _, setting in ipairs(settings) do
	if SETTING_KINDS[setting.type] and not setting.hidden then
		table.insert(editModeSettings, {
			kind = SETTING_KINDS[setting.type],
			name = setting.title,
			desc = setting.tooltip,
			default = setting.default,
			minValue = setting.minValue,
			maxValue = setting.maxValue,
			valueStep = setting.valueStep,
			get = function()
				return ns:GetOption(setting.key)
			end,
			set = function(_, value)
				ns:SetOption(setting.key, value)
			end,
			disabled = setting.requires and function()
				return not ns:GetOption(setting.requires)
			end,
		})
	end
end

LibEditMode:AddSystemSettings(Enum.EditModeSystem.Minimap, editModeSettings)

LibEditMode.internal.extension:ClearAllPoints()
LibEditMode.internal.extension:SetPoint("BOTTOM", EditModeSystemSettingsDialog, "TOP")
