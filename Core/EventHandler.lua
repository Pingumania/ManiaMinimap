local addonName, A = ...

local eventHandler = CreateFrame('Frame')
local callbacks = {}
local EventMixin = {}

function EventMixin:RegisterEvent(event, callback)
	assert(A:IsEventValid(event), 'arg1 must be an event')
	assert(type(callback) == 'function', 'arg2 must be a function')

	if not callbacks[event] then
		callbacks[event] = {}
	end

	table.insert(callbacks[event], {
		callback = callback,
		owner = self,
	})

	if not eventHandler:IsEventRegistered(event) then
		eventHandler:RegisterEvent(event)
	end
end

function EventMixin:UnregisterEvent(event, callback)
	assert(A:IsEventValid(event), 'arg1 must be an event')
	assert(type(callback) == 'function', 'arg2 must be a function')

	if callbacks[event] then
		for index, data in next, callbacks[event] do
			if data.owner == self and data.callback == callback then
				callbacks[event][index] = nil
				break
			end
		end

		if #callbacks[event] == 0 then
			eventHandler:UnregisterEvent(event)
		end
	end
end

function EventMixin:UnregisterAllEvents(callback)
	if callback then
		assert(type(callback) == 'function', 'arg1 must be a function')
	end

	for event, cbs in next, callbacks do
		for _, data in next, cbs do
			if data.owner == self then
				if callback then
					if data.callback == callback then
						self:UnregisterEvent(event, data.callback)
					end
				else
					self:UnregisterEvent(event, data.callback)
				end
			end
		end
	end
end

function EventMixin:IsEventRegistered(event, callback)
	assert(A:IsEventValid(event), 'arg1 must be an event')
	assert(type(callback) == 'function', 'arg2 must be a function')

	if callbacks[event] then
		for _, data in next, callbacks[event] do
			if data.callback == callback then
				return true
			end
		end
	end
end

function EventMixin:TriggerEvent(event, ...)
	if callbacks[event] then
		for _, data in next, callbacks[event] do
			local successful, ret = pcall(data.callback, data.owner, ...)
			if not successful then
				error(ret)
			elseif ret then
				EventMixin.UnregisterEvent(data.owner, event, data.callback)
			end
		end
	end
end

eventHandler:SetScript('OnEvent', function(_, event, ...)
	EventMixin:TriggerEvent(event, ...)
end)

A.EventMixin = EventMixin

A = setmetatable(A, {
	__newindex = function(t, key, value)
		if key == 'OnLoad' then
			A:RegisterEvent('ADDON_LOADED', function(self, name)
				if name == addonName then
					local successful, ret = pcall(value, self)
					if not successful then
						error(ret)
					end
					return true
				end
			end)
		elseif key == 'OnLogin' then
			A:RegisterEvent('PLAYER_LOGIN', function(self)
				local successful, ret = pcall(value, self)
				if not successful then
					error(ret)
				end
				return true
			end)
		elseif A:IsEventValid(key) then
			EventMixin.RegisterEvent(t, key, value)
		else
			rawset(t, key, value)
		end
	end,
	__index = function(t, key)
		if A:IsEventValid(key) then
			return function(_, ...)
				EventMixin.TriggerEvent(t, key, ...)
			end
		else
			return rawget(t, key)
		end
	end,
})

Mixin(A, EventMixin)