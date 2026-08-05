local _, A = ...

function GetMinimapShape()
	return "SQUARE"
end

local POSITIONS = {
	ExpansionLandingPageMinimapButton = { "TOPLEFT", MinimapBackdrop, "TOPLEFT", -11, -172 },
	AddonCompartmentFrame = { "TOPLEFT", GameTimeFrame, "TOPRIGHT", 0, 0 },
	IndicatorFrame = { "TOPLEFT", Minimap, "TOPLEFT", 5, -5 },
	InstanceDifficulty = { "TOPRIGHT", Minimap, "TOPRIGHT", -10, 1 },
}

local BORDER_LAYOUT = {
	TopEdge           = { atlas = "_UI-HUD-ActionBar-Frame-NineSlice-EdgeTop" },
	BottomEdge        = { atlas = "_UI-HUD-ActionBar-Frame-NineSlice-EdgeBottom" },
	LeftEdge          = { atlas = "!UI-HUD-ActionBar-Frame-NineSlice-EdgeLeft" },
	RightEdge         = { atlas = "!UI-HUD-ActionBar-Frame-NineSlice-EdgeRight" },
	TopLeftCorner     = { atlas = "UI-HUD-ActionBar-Frame-NineSlice-CornerTopLeft" },
	TopRightCorner    = { atlas = "UI-HUD-ActionBar-Frame-NineSlice-CornerTopRight" },
	BottomLeftCorner  = { atlas = "UI-HUD-ActionBar-Frame-NineSlice-CornerBottomLeft" },
	BottomRightCorner = { atlas = "UI-HUD-ActionBar-Frame-NineSlice-CornerBottomRight" },
}

local BORDER_SCALE = 0.8

local borderFrame

local function SetHidden(hidden, ...)
	for index = 1, select("#", ...) do
		local object = select(index, ...)

		if hidden then
			A:HideFrame(object)
		else
			A:ShowFrame(object)
		end
	end
end

local function ApplyBorder()
	local enabled = A:GetOption("border")

	if enabled and not borderFrame then
		borderFrame = CreateFrame("Frame", nil, Minimap)
		borderFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -3, 3)
		borderFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 7, -6)

		NineSliceUtil.ApplyLayout(borderFrame, BORDER_LAYOUT)

		borderFrame:SetIgnoreParentScale(true)
		borderFrame:SetScale(BORDER_SCALE)
	end

	if borderFrame then
		borderFrame:SetShown(enabled)
	end

	SetHidden(enabled, MinimapBorder, MinimapBorderTop)
end

local function ApplyWidgets()
	SetHidden(A:GetOption("hideZoomButtons"), Minimap.ZoomIn, Minimap.ZoomOut, Minimap.ZoomHitArea,
		MinimapZoomIn, MinimapZoomOut, MinimapToggleButton)
	SetHidden(A:GetOption("hideCalendar"), GameTimeFrame)
end

function A:OnLoad()
	if A:IsClassicEra() then
		Minimap:SetSize(200, 200)
		Minimap:ClearAllPoints()
		Minimap:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT", -20, -20)
		MinimapZoneTextButton:ClearAllPoints()
		MinimapZoneTextButton:SetPoint("TOP", Minimap, "TOP", 0, -5)
	end
end

function A:OnLogin()
	Minimap:SetMaskTexture("Interface\\AddOns\\ManiaMinimap\\Media\\Mask.blp")

	if A:IsRetail() then
		MinimapCluster.MinimapContainer:ClearAllPoints()
		MinimapCluster.MinimapContainer:SetPoint("TOP", MinimapCluster, "TOP", 7, -10)
		MinimapCluster.BorderTop:ClearAllPoints()
		MinimapCluster.BorderTop:SetPoint("TOP", MinimapCluster, "TOP", 0, -4)
	end

	if A:IsClassicEra() then
		TimeManagerClockButton:ClearAllPoints()
		TimeManagerClockButton:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, 3)
	end

	A:Hide(MinimapCompassTexture)
	A:Hide(MinimapNorthTag)

	ApplyWidgets()
	ApplyBorder()

	if A:IsRetail() then
		ExpansionLandingPageMinimapButton:SetSize(36, 36)
		ExpansionLandingPageMinimapButton:ClearAllPoints()
		ExpansionLandingPageMinimapButton:SetPoint(unpack(POSITIONS.ExpansionLandingPageMinimapButton))

		hooksecurefunc(ExpansionLandingPageMinimapButton, "SetLandingPageIconFromAtlases", function()
			ExpansionLandingPageMinimapButton:SetSize(36, 36)
		end)

		hooksecurefunc(ExpansionLandingPageMinimapButton, "UpdateIconForGarrison", function()
			ExpansionLandingPageMinimapButton:ClearAllPoints()
			ExpansionLandingPageMinimapButton:SetPoint(unpack(POSITIONS.ExpansionLandingPageMinimapButton))
		end)

		hooksecurefunc(ExpansionLandingPageMinimapButton, "SetLandingPageIconOffset", function()
			ExpansionLandingPageMinimapButton:ClearAllPoints()
			ExpansionLandingPageMinimapButton:SetPoint(unpack(POSITIONS.ExpansionLandingPageMinimapButton))
		end)

		AddonCompartmentFrame:ClearAllPoints()
		AddonCompartmentFrame:SetPoint(unpack(POSITIONS.AddonCompartmentFrame))

		MinimapCluster.IndicatorFrame:ClearAllPoints()
		MinimapCluster.IndicatorFrame:SetPoint(unpack(POSITIONS.IndicatorFrame))

		hooksecurefunc("MiniMapIndicatorFrame_UpdatePosition", function()
			MinimapCluster.IndicatorFrame:ClearAllPoints()
			MinimapCluster.IndicatorFrame:SetPoint(unpack(POSITIONS.IndicatorFrame))
		end)

		MinimapCluster.InstanceDifficulty:ClearAllPoints()
		MinimapCluster.InstanceDifficulty:SetPoint(unpack(POSITIONS.InstanceDifficulty))
		MinimapCluster.InstanceDifficulty:SetSize(30, 31)

		hooksecurefunc(MinimapCluster, "SetHeaderUnderneath", function()
			MinimapCluster.IndicatorFrame:ClearAllPoints()
			MinimapCluster.IndicatorFrame:SetPoint(unpack(POSITIONS.IndicatorFrame))
			MinimapCluster.InstanceDifficulty:ClearAllPoints()
			MinimapCluster.InstanceDifficulty:SetPoint(unpack(POSITIONS.InstanceDifficulty))
		end)
	end

	A:ApplyCoords()

	A:RegisterOptionCallback("border", ApplyBorder)
	A:RegisterOptionCallback("hideZoomButtons", ApplyWidgets)
	A:RegisterOptionCallback("hideCalendar", ApplyWidgets)
	A:RegisterOptionCallback("coords", function()
		A:ApplyCoords()
	end)
end
