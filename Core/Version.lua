local _, A = ...

function A:IsRetail()
	return WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
end

function A:IsClassicEra()
	return WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
end

function A:IsClassic()
	return not A:IsRetail() and not A:IsClassicEra()
end

local _, buildVersion, _, interfaceVersion = GetBuildInfo()
function A:HasVersion(interface)
	return interfaceVersion >= interface
end

function A:HasBuild(build, interface)
	if interface and interfaceVersion < interface then
		return
	end

	return tonumber(buildVersion) >= build
end