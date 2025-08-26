local _, A = ...

local gsub = gsub
local format = format

local function GetFormattedCoordinates(x, y)
	return gsub(format("|cfff0f0f0%.2f|r", x*100), "%.(.+)", "|cffa0a0a0.%1|r"),
			gsub(format("|cfff0f0f0%.2f|r", y*100), "%.(.+)", "|cffa0a0a0.%1|r")
end

local function GetPlayerCoordinates()
	local instanceID = C_Map.GetBestMapForUnit("player")
	if instanceID then
		local pos = C_Map.GetPlayerMapPosition(instanceID, "player")
		if pos then
			return pos.x, pos.y
		end
	end
end

local function OnUpdateMinimap(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed < self.delay then
		return
	end

	if self.player then
		local pX, pY = GetPlayerCoordinates()
		if pX and pY then
			self.player:SetFormattedText("%s, %s", GetFormattedCoordinates(pX, pY))
		else
			self.player:SetText(" ")
		end
	end

	self.elapsed = 0
end

function A:InitCoords()
	local mmCoords = CreateFrame("Frame", nil, Minimap)
	mmCoords:SetFrameStrata("DIALOG")
	mmCoords.elapsed = 0
	mmCoords.delay = 0.25

	local mmPlayer = mmCoords:CreateFontString()
	mmPlayer:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
	mmPlayer:SetDrawLayer("OVERLAY")
	mmPlayer:SetJustifyH("RIGHT")
	mmPlayer:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", -5, -5)

	mmCoords.player = mmPlayer
    mmCoords:SetScript("OnUpdate", OnUpdateMinimap)
end