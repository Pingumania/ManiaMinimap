local _, ns = ...

local UPDATE_DELAY = 0.25

local coordsFrame

local function GetPlayerCoordinates()
	local uiMapID = C_Map.GetBestMapForUnit("player")
	if uiMapID then
		local pos = C_Map.GetPlayerMapPosition(uiMapID, "player")
		if pos then
			return pos.x, pos.y
		end
	end
end

local function OnUpdateMinimap(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed < UPDATE_DELAY then
		return
	end

	self.elapsed = 0

	local x, y = GetPlayerCoordinates()
	if x and y then
		self.Text:SetFormattedText("%s, %s", ns:FormatCoordinates(x, y))
	else
		self.Text:SetText(" ")
	end
end

function ns:ApplyCoords()
	local enabled = ns:GetOption("coords")

	if enabled and not coordsFrame then
		coordsFrame = CreateFrame("Frame", nil, Minimap)
		coordsFrame:SetFrameStrata("DIALOG")
		coordsFrame.elapsed = 0

		coordsFrame.Text = coordsFrame:CreateFontString(nil, "OVERLAY")
		coordsFrame.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
		coordsFrame.Text:SetJustifyH("RIGHT")
		coordsFrame.Text:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", -5, -5)
	end

	if not coordsFrame then
		return
	end

	coordsFrame:SetShown(enabled)
	coordsFrame:SetScript("OnUpdate", enabled and OnUpdateMinimap or nil)
end
