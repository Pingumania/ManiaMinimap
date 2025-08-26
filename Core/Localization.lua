local _, A = ...

local localizations = {}
local locale = GetLocale()

A.L = setmetatable({}, {
	__index = function(_, key)
		local localeTable = localizations[locale]
		return localeTable and localeTable[key] or tostring(key)
	end,
	__call = function(_, newLocale)
		localizations[newLocale] = localizations[newLocale] or {}
		return localizations[newLocale]
	end,
})