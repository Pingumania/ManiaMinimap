local _, ns = ...

function GetMinimapShape()
	return "SQUARE"
end

local MASK = "Interface\\AddOns\\ManiaMinimap\\Media\\Mask.blp"
local PLATE_ATLAS = "ui-hud-minimap-header-button"
local PLATE_SLICE = 12
local MAP_INSET = 2
local BAND_HEIGHT = 21
local HEADER_HEIGHT = 23
local HEADER_TOP = -1
local HEADER_SIDE = 6
local HEADER_GAP = 2
local CLOCK_WIDTH = 50
local TEXT_INSET = 6
local COMPARTMENT_ART_WIDTH = 23
local COMPARTMENT_ART_HEIGHT = 22
local COMPARTMENT_ART_SCALE = 1.2
local COMPARTMENT_ART_SHIFT = 0.5
local ROW_LEVEL = 5
local CORNER_OVERHANG = 6
local ART_KEYS = { "StateTexture", "AddTexture" }
local BUTTON_RADIUS = 5
local BUTTON_CORNER_INSET = 10
local RING_FILE = 136430
local RING_ATLAS = "UI-HUD-Minimap-Frame-Cycle"
local BACKGROUND_FILE = 136467

local FRAME_LAYOUT = {
	disableSharpening = true,
	TopLeftCorner = { layer = "OVERLAY", atlas = "UI-Frame-Metal-CornerTopLeft", x = -14, y = 16 },
	TopRightCorner = { layer = "OVERLAY", atlas = "UI-Frame-Metal-CornerTopRight", x = 4, y = 16 },
	BottomLeftCorner = { layer = "OVERLAY", atlas = "UI-Frame-Metal-CornerBottomLeft", x = -14, y = -3 },
	BottomRightCorner = { layer = "OVERLAY", atlas = "UI-Frame-Metal-CornerBottomRight", x = 4, y = -3 },
	TopEdge = { layer = "OVERLAY", atlas = "_UI-Frame-Metal-EdgeTop" },
	BottomEdge = { layer = "OVERLAY", atlas = "_UI-Frame-Metal-EdgeBottom" },
	LeftEdge = { layer = "OVERLAY", atlas = "!UI-Frame-Metal-EdgeLeft" },
	RightEdge = { layer = "OVERLAY", atlas = "!UI-Frame-Metal-EdgeRight" },
}

local container = MinimapCluster.MinimapContainer
local artFrame, header

local function SetHidden(hidden, ...)
	for index = 1, select("#", ...) do
		local object = select(index, ...)

		if hidden then
			ns:HideFrame(object)
		else
			ns:ShowFrame(object)
		end
	end
end

local function Raise(object, extra)
	object:SetFrameLevel(Minimap:GetFrameLevel() + ROW_LEVEL + (extra or 0))
end

local function Adopt(object)
	object:SetParent(container)
	Raise(object)
end

local function FitArt(button)

	for _, key in ipairs(ART_KEYS) do
		if button[key] then
			button[key]:ClearAllPoints()
			button[key]:SetAllPoints(button)
		end
	end
end

local function FitCompartmentArt(button)
	local unit = button:GetWidth() / COMPARTMENT_ART_WIDTH * COMPARTMENT_ART_SCALE
	local growX = (COMPARTMENT_ART_WIDTH * unit - button:GetWidth()) / 2
	local growY = (COMPARTMENT_ART_HEIGHT * unit - button:GetHeight()) / 2
	local shift = COMPARTMENT_ART_SHIFT * unit

	for _, key in ipairs(ART_KEYS) do
		if button[key] then
			button[key]:ClearAllPoints()
			ns:SetPoint(button[key], "TOPLEFT", button, "TOPLEFT", -growX, growY - shift)
			ns:SetPoint(button[key], "BOTTOMRIGHT", button, "BOTTOMRIGHT", growX, -growY - shift)
		end
	end
end

local function SlicePlate(texture)
	texture:SetAtlas(PLATE_ATLAS)
	texture:ClearAllPoints()
	texture:SetAllPoints(header)
	texture:SetTextureSliceMargins(PLATE_SLICE, PLATE_SLICE, PLATE_SLICE, PLATE_SLICE)
	texture:SetTextureSliceMode(Enum.UITextureSliceMode.Stretched)
end

local function SetFontSize(text, size)
	local font, _, flags = text:GetFont()
	text:SetFont(font, size, flags)
end

local function ApplyFonts()
	local size = ns:GetOption("headerFontSize")

	SetFontSize(MinimapZoneText, size)
	if AddonCompartmentFrame.Text then
		AddonCompartmentFrame.Text:SetScale(1)
		SetFontSize(AddonCompartmentFrame.Text, size)
	end
	if TimeManagerClockTicker then
		SetFontSize(TimeManagerClockTicker, size)
	end
end

local function KeepSquare(_, texture)
	if texture ~= MASK then
		Minimap:SetMaskTexture(MASK)
	end
end

local function PlaceIndicators()
	MinimapCluster.IndicatorFrame:ClearAllPoints()
	MinimapCluster.IndicatorFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 4, -4)
end

local function PlaceCorner()
	local corner = MinimapCluster.DielFrame or ExpansionLandingPageMinimapButton
	if not corner then return end

	corner:ClearAllPoints()
	corner:SetPoint("BOTTOMLEFT", artFrame, "BOTTOMLEFT", -CORNER_OVERHANG, -CORNER_OVERHANG)
	Raise(corner, 1)
end

local function Layout()
	local cluster = MinimapCluster
	local tracking = cluster.Tracking
	local zone = cluster.ZoneTextButton
	local compartment = AddonCompartmentFrame
	local rightWidth = HEADER_HEIGHT + HEADER_GAP

	if not ns:GetOption("hideCalendar") then
		rightWidth = rightWidth + HEADER_HEIGHT + HEADER_GAP
	end

	container:ClearAllPoints()
	container:SetPoint("TOP", cluster, "TOP", 0, -10)
	zone:SetScale(1)

	Minimap:ClearAllPoints()
	Minimap:SetPoint("TOP", container, "TOP", 0, -BAND_HEIGHT)

	tracking:ClearAllPoints()
	ns:SetPoint(tracking, "TOPLEFT", artFrame, "TOPLEFT", HEADER_SIDE, -HEADER_TOP)

	header:ClearAllPoints()
	ns:SetPoint(header, "LEFT", tracking, "RIGHT", HEADER_GAP, 0)
	ns:SetPoint(header, "RIGHT", artFrame, "RIGHT", -HEADER_SIDE - rightWidth, 0)

	if cluster.BorderTop then
		cluster.BorderTop:ClearAllPoints()
		cluster.BorderTop:SetAllPoints(header)
	end

	zone:ClearAllPoints()
	zone:SetPoint("TOPLEFT", header, "TOPLEFT")
	zone:SetPoint("BOTTOMRIGHT", header, "BOTTOMRIGHT", -CLOCK_WIDTH, 0)

	GameTimeFrame:ClearAllPoints()
	ns:SetPoint(GameTimeFrame, "LEFT", header, "RIGHT", HEADER_GAP, 0)

	compartment:ClearAllPoints()
	if ns:GetOption("hideCalendar") then
		ns:SetPoint(compartment, "LEFT", header, "RIGHT", HEADER_GAP, 0)
	else
		ns:SetPoint(compartment, "LEFT", GameTimeFrame, "RIGHT", HEADER_GAP, 0)
	end

	PlaceIndicators()
	PlaceCorner()

	if cluster.InstanceDifficulty then
		cluster.InstanceDifficulty:ClearAllPoints()
		cluster.InstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -4, -4)
	end
end

local function StyleHeader()
	local cluster = MinimapCluster
	local tracking = cluster.Tracking
	local zone = cluster.ZoneTextButton

	header = CreateFrame("Frame", nil, container)
	header:SetHeight(HEADER_HEIGHT)
	Raise(header, -1)

	if cluster.BorderTop then
		cluster.BorderTop:SetParent(container)
		Raise(cluster.BorderTop, -1)
	else
		SlicePlate(header:CreateTexture(nil, "BACKGROUND"))
		if zone.StateTexture then
			ns:Hide(zone.StateTexture)
		end
		if zone.AddTexture then
			SlicePlate(zone.AddTexture)
		end
	end

	ns:SetSize(tracking, HEADER_HEIGHT, HEADER_HEIGHT)
	if tracking.Button.StateTexture then
		tracking.Background:Hide()
		tracking.Button:ClearAllPoints()
		tracking.Button:SetAllPoints(tracking)
		FitArt(tracking.Button)
	end

	ns:SetSize(GameTimeFrame, HEADER_HEIGHT, HEADER_HEIGHT)
	FitArt(GameTimeFrame)
	ns:SetSize(AddonCompartmentFrame, HEADER_HEIGHT, HEADER_HEIGHT)
	FitCompartmentArt(AddonCompartmentFrame)

	MinimapZoneText:ClearAllPoints()
	MinimapZoneText:SetPoint("TOPLEFT", zone, "TOPLEFT", TEXT_INSET, 0)
	MinimapZoneText:SetPoint("BOTTOMRIGHT", zone, "BOTTOMRIGHT")
	MinimapZoneText:SetJustifyH("LEFT")
	MinimapZoneText:SetWordWrap(false)

	Adopt(tracking)
	Adopt(zone)
	Adopt(GameTimeFrame)
	Adopt(AddonCompartmentFrame)
	Adopt(cluster.IndicatorFrame)
	if cluster.InstanceDifficulty then
		Adopt(cluster.InstanceDifficulty)
	end

	ns:ContinueOnAddOnLoaded("Blizzard_TimeManager", function()
		Adopt(TimeManagerClockButton)
		TimeManagerClockButton:ClearAllPoints()
		TimeManagerClockButton:SetPoint("TOPRIGHT", header, "TOPRIGHT")
		TimeManagerClockButton:SetSize(CLOCK_WIDTH, HEADER_HEIGHT)
		TimeManagerClockTicker:ClearAllPoints()
		TimeManagerClockTicker:SetPoint("RIGHT", TimeManagerClockButton, "RIGHT", -TEXT_INSET, 0)
		ApplyFonts()
	end)
end

local function CreateArt()
	artFrame = CreateFrame("Frame", nil, Minimap)
	artFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -MAP_INSET, BAND_HEIGHT)
	artFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", MAP_INSET, -MAP_INSET)
	NineSliceUtil.ApplyLayout(artFrame, FRAME_LAYOUT)
end

local buttonAngles = {}
local placingButton

local function FindRegion(button, file, atlas)
	for _, region in ipairs({ button:GetRegions() }) do
		if region:IsObjectType("Texture") and (region:GetTexture() == file or (atlas and region:GetAtlas() == atlas)) then
			return region
		end
	end
end

local function SaveAngle(button)
	local buttonX, buttonY = button:GetCenter()
	local mapX, mapY = Minimap:GetCenter()
	buttonAngles[button] = math.atan2(buttonY - mapY, buttonX - mapX)
end

local function PlaceButton(button)
	local angle = buttonAngles[button]
	local radius = Minimap:GetWidth() / 2 + BUTTON_RADIUS
	local diagonal = sqrt(2 * radius * radius) - BUTTON_CORNER_INSET
	local x = math.max(-radius, math.min(math.cos(angle) * diagonal, radius))
	local y = math.max(-radius, math.min(math.sin(angle) * diagonal, radius))

	placingButton = true
	button:ClearAllPoints()
	button:SetPoint("CENTER", Minimap, "CENTER", x, y)
	placingButton = false
end

local function OnButtonSetPoint(button)
	if placingButton then return end

	SaveAngle(button)
	PlaceButton(button)
end

local function CopyRegion(from, to)
	local point, _, relativePoint, x, y = from:GetPoint(1)

	to:SetTexture(from:GetTexture())
	to:SetTexCoord(from:GetTexCoord())
	to:SetSize(from:GetSize())
	to:ClearAllPoints()
	to:SetPoint(point, to:GetParent(), relativePoint, x, y)
end

local function StyleButton(button, ring, model)
	local background = FindRegion(button, BACKGROUND_FILE) or button:CreateTexture(nil, "BACKGROUND")

	button:SetSize(model:GetSize())
	CopyRegion(model.border, ring)
	CopyRegion(model.background, background)
	if button.icon then
		button.icon:SetSize(model.icon:GetSize())
	end
end

local function CatchButtons()
	local libDBIcon = LibStub("LibDBIcon-1.0", true)
	local modelName = libDBIcon and libDBIcon:GetButtonList()[1]
	local model = modelName and libDBIcon:GetMinimapButton(modelName)
	local name, ring

	for _, parent in ipairs({ Minimap, MinimapBackdrop }) do
		for _, child in ipairs({ parent:GetChildren() }) do
			name = child:GetName()
			ring = not buttonAngles[child] and name and not name:find("^LibDBIcon10_") and child:IsObjectType("Button")
				and not (InCombatLockdown() and child:IsProtected()) and FindRegion(child, RING_FILE, RING_ATLAS)
			if ring then
				if model then
					StyleButton(child, ring, model)
				end
				SaveAngle(child)
				PlaceButton(child)
				hooksecurefunc(child, "SetPoint", OnButtonSetPoint)
			end
		end
	end
end

local function ApplySize()
	local size = ns:GetOption("mapSize")
	local zoom = Minimap:GetZoom()
	Minimap:SetSize(size, size)
	Minimap:SetZoom(zoom > 0 and zoom - 1 or zoom + 1)
	Minimap:SetZoom(zoom)

	local libDBIcon = LibStub("LibDBIcon-1.0", true)
	if libDBIcon then
		for _, name in ipairs(libDBIcon:GetButtonList()) do
			libDBIcon:Refresh(name)
			if libDBIcon.ResetButtonBorder then
				libDBIcon:ResetButtonBorder(name)
				libDBIcon:ResetButtonBackground(name)
				libDBIcon:ResetButtonIcon(name)
			end
		end
	end

	for button in pairs(buttonAngles) do
		PlaceButton(button)
	end
end

local function ApplyWidgets()
	SetHidden(ns:GetOption("hideZoomButtons"), Minimap.ZoomIn, Minimap.ZoomOut, Minimap.ZoomHitArea)
	SetHidden(ns:GetOption("hideCalendar"), GameTimeFrame)
	if MinimapCluster.DielFrame then
		SetHidden(ns:GetOption("hideDayNight"), MinimapCluster.DielFrame)
	end
	Layout()
end

function ns:OnLogin()
	if C_CVar.GetCVarBool("rotateMinimap") then
		C_CVar.SetCVar("rotateMinimap", "0")
	end

	ApplySize()
	Minimap:SetMaskTexture(MASK)
	hooksecurefunc(Minimap, "SetMaskTexture", KeepSquare)

	ns:Hide(MinimapCompassTexture)
	if MinimapCompassTextureUnderlay then
		ns:Hide(MinimapCompassTextureUnderlay)
	end

	CreateArt()
	StyleHeader()
	ApplyFonts()
	ApplyWidgets()

	hooksecurefunc(MinimapCluster, "SetHeaderUnderneath", Layout)
	hooksecurefunc(MinimapCluster, "SetEditModeScale", Layout)
	hooksecurefunc("MiniMapIndicatorFrame_UpdatePosition", PlaceIndicators)
	if MinimapCluster.UpdateMinimapConfig then
		hooksecurefunc(MinimapCluster, "UpdateMinimapConfig", Layout)
	end

	if ns:IsRetail() then
		ExpansionLandingPageMinimapButton:SetSize(36, 36)
		hooksecurefunc(ExpansionLandingPageMinimapButton, "SetLandingPageIconFromAtlases", function()
			ExpansionLandingPageMinimapButton:SetSize(36, 36)
		end)
		hooksecurefunc(ExpansionLandingPageMinimapButton, "UpdateIconForGarrison", PlaceCorner)
		hooksecurefunc(ExpansionLandingPageMinimapButton, "SetLandingPageIconOffset", PlaceCorner)

		MinimapCluster.InstanceDifficulty:SetSize(30, 31)
	end

	ns:ApplyCoords()

	ns:RegisterOptionCallback("hideZoomButtons", ApplyWidgets)
	ns:RegisterOptionCallback("hideCalendar", ApplyWidgets)
	ns:RegisterOptionCallback("hideDayNight", ApplyWidgets)
	ns:RegisterOptionCallback("headerFontSize", ApplyFonts)
	ns:RegisterOptionCallback("mapSize", ApplySize)
	ns:RegisterEvent("PLAYER_ENTERING_WORLD", CatchButtons)
	ns:RegisterOptionCallback("coords", function()
		ns:ApplyCoords()
	end)
	ns:RegisterOptionCallback("coordsFontSize", function()
		ns:ApplyCoordsFont()
	end)
	ns:RegisterOptionCallback("coordsOffsetX", function()
		ns:ApplyCoordsPosition()
	end)
	ns:RegisterOptionCallback("coordsOffsetY", function()
		ns:ApplyCoordsPosition()
	end)
end
