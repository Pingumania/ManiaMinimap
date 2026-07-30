local _, A = ...

function GetMinimapShape()
    return "SQUARE"
end

local Positions = {
    ["ExpansionLandingPageMinimapButton"] = { "TOPLEFT", MinimapBackdrop, "TOPLEFT", -11, -172 },
    ["AddonCompartmentFrame"] = { "TOPLEFT", GameTimeFrame, "TOPRIGHT", 0, 0 },
    ["IndicatorFrame"] = { "TOPLEFT", Minimap, "TOPLEFT", 5, -5 },
    ["InstanceDifficulty"] = { "TOPRIGHT", Minimap,"TOPRIGHT", -10, 1 }
}

function A:OnLoad()
    if A.IsClassicEra() then
        Minimap:SetSize(200, 200)
        Minimap:ClearAllPoints()
        Minimap:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT", -20, -20)
        MinimapZoneTextButton:ClearAllPoints()
        MinimapZoneTextButton:SetPoint("TOP", Minimap, "TOP", 0, -5)
    end
end

function A:OnLogin()
    Minimap:SetMaskTexture("Interface\\AddOns\\ManiaMinimap\\Media\\Mask.blp")

    if A.IsRetail() then
        MinimapCluster.MinimapContainer:ClearAllPoints()
        MinimapCluster.MinimapContainer:SetPoint("TOP", MinimapCluster, "TOP", 7, -10)
        MinimapCluster.BorderTop:ClearAllPoints()
        MinimapCluster.BorderTop:SetPoint("TOP", MinimapCluster, "TOP", 0, -4)
    end

    if A.IsClassicEra() then
        TimeManagerClockButton:ClearAllPoints()
        TimeManagerClockButton:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, 3)
    end

    A:Hide(MinimapCompassTexture)
    A:Hide(MinimapZoomIn)
    A:Hide(MinimapZoomOut)
    A:Hide(MinimapNorthTag)
    A:Hide(MinimapBorder)
    A:Hide(MinimapBorderTop)
    A:Hide(MinimapToggleButton)
    A:Hide(GameTimeFrame)

    local borderFrame = CreateFrame("Frame")
    borderFrame:SetParent(Minimap)
    borderFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -3, 3)
    borderFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 7, -6)

    local layout = {
        TopEdge           = { atlas = "_UI-HUD-ActionBar-Frame-NineSlice-EdgeTop" },
        BottomEdge        = { atlas = "_UI-HUD-ActionBar-Frame-NineSlice-EdgeBottom" },
        LeftEdge          = { atlas = "!UI-HUD-ActionBar-Frame-NineSlice-EdgeLeft" },
        RightEdge         = { atlas = "!UI-HUD-ActionBar-Frame-NineSlice-EdgeRight" },
        TopLeftCorner     = { atlas = "UI-HUD-ActionBar-Frame-NineSlice-CornerTopLeft" },
        TopRightCorner    = { atlas = "UI-HUD-ActionBar-Frame-NineSlice-CornerTopRight" },
        BottomLeftCorner  = { atlas = "UI-HUD-ActionBar-Frame-NineSlice-CornerBottomLeft" },
        BottomRightCorner = { atlas = "UI-HUD-ActionBar-Frame-NineSlice-CornerBottomRight" }
    }

    NineSliceUtil.ApplyLayout(borderFrame, layout)

    borderFrame:Show()
    borderFrame:SetIgnoreParentScale(true)
    borderFrame:SetScale(.8)

    if A.IsRetail() then
        ExpansionLandingPageMinimapButton:SetSize(36, 36)
        ExpansionLandingPageMinimapButton:ClearAllPoints()
        ExpansionLandingPageMinimapButton:SetPoint(unpack(Positions["ExpansionLandingPageMinimapButton"]))

        hooksecurefunc(ExpansionLandingPageMinimapButton, "SetLandingPageIconFromAtlases", function()
            ExpansionLandingPageMinimapButton:SetSize(36, 36)
        end)

        hooksecurefunc(ExpansionLandingPageMinimapButton, "UpdateIconForGarrison", function()
            ExpansionLandingPageMinimapButton:ClearAllPoints()
            ExpansionLandingPageMinimapButton:SetPoint(unpack(Positions["ExpansionLandingPageMinimapButton"]))
        end)

        hooksecurefunc(ExpansionLandingPageMinimapButton, "SetLandingPageIconOffset", function()
            ExpansionLandingPageMinimapButton:ClearAllPoints()
            ExpansionLandingPageMinimapButton:SetPoint(unpack(Positions["ExpansionLandingPageMinimapButton"]))
        end)

        AddonCompartmentFrame:ClearAllPoints()
        AddonCompartmentFrame:SetPoint(unpack(Positions["AddonCompartmentFrame"]))

        MinimapCluster.IndicatorFrame:ClearAllPoints()
        MinimapCluster.IndicatorFrame:SetPoint(unpack(Positions["IndicatorFrame"]))

        hooksecurefunc("MiniMapIndicatorFrame_UpdatePosition", function()
            MinimapCluster.IndicatorFrame:ClearAllPoints()
            MinimapCluster.IndicatorFrame:SetPoint(unpack(Positions["IndicatorFrame"]))
        end)

        MinimapCluster.InstanceDifficulty:ClearAllPoints()
        MinimapCluster.InstanceDifficulty:SetPoint(unpack(Positions["InstanceDifficulty"]))
        MinimapCluster.InstanceDifficulty:SetSize(30, 31)

            hooksecurefunc(MinimapCluster, "SetHeaderUnderneath", function()
            MinimapCluster.IndicatorFrame:ClearAllPoints()
            MinimapCluster.IndicatorFrame:SetPoint(unpack(Positions["IndicatorFrame"]))
            MinimapCluster.InstanceDifficulty:ClearAllPoints()
            MinimapCluster.InstanceDifficulty:SetPoint(unpack(Positions["InstanceDifficulty"]))
        end)
    end

    A:InitCoords()
end
