local _, A = ...

local hidden = CreateFrame('Frame')
hidden:Hide()

function A:Hide(object, ...)
	if type(object) == 'string' then
		object = _G[object]
	end

	if ... then
		for index = 1, select('#', ...) do
			object = object[select(index, ...)]
		end
	end

	if object then
		object:SetParent(hidden)
		object.SetParent = nop

		if object.UnregisterAllEvents then
			object:UnregisterAllEvents()
		end
	end
end