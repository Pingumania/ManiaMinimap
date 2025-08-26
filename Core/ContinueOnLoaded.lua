local _, A = ...

function A:IsAddOnEnabled(name)
	return C_AddOns.GetAddOnEnableState(name, UnitName('player')) > 0
end


local addonCallbacks = {}
function A:ContinueOnAddOnLoaded(addonName, callback)
	if C_AddOns.IsAddOnLoaded(addonName) then
		callback(self)
	else
		table.insert(addonCallbacks, {
			addonName = addonName,
			callback = callback,
		})
	end
end

A:RegisterEvent('ADDON_LOADED', function(self, addonName)
	for _, info in next, addonCallbacks do
		if info.addonName == addonName then
			local successful, err = pcall(info.callback)
			if not successful then
				error(err)
			end
		end
	end
end)