local addonName, A = ...

local defaults = {
    enabled = true,
}

local function RemoveStaleKeys(saved, defaults)
    for key, value in pairs(saved) do
        local defaultValue = defaults[key]

        if defaultValue == nil then
            saved[key] = nil

        elseif type(value) == "table" and type(defaultValue) == "table" then
            RemoveStaleKeys(value, defaultValue)
        end
    end
end

A:ContinueOnAddOnLoaded(addonName, function()
	if not AddonTemplateDB then
		AddonTemplateDB = {}
	end

    RemoveStaleKeys(AddonTemplateDB, defaults)
	A.Config = setmetatable(AddonTemplateDB, { __index = defaults })
end)
